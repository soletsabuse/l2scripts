using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace PvpPanel
{
    /// <summary>
    /// The PvP focus server inside the panel (it was pvp_server.py - the same ports, the same protocol: pvp.html and
    /// pvp_focus.txt did not change):
    ///   http://127.0.0.1:7790/   the page (pvp.html of the PvP folder) and its API
    ///   127.0.0.1:7791 (TCP)     the bots, one line per message, CRLF:
    ///       bot -> server:  HELLO|&lt;character&gt;   STATE|&lt;json&gt;   PONG
    ///       server -> bot:  RELOAD   PING   WATCH|1 / WATCH|0 (a page watches / none: the bot builds its STATE only
    ///                       while 1)   STATRESET   K (read: the bot's next line is not held back by Nagle)
    ///       assist via the server (Relay.cs): bot -> N|T|&lt;oid&gt;|&lt;name&gt;; server -> N|LINK, N|ROOM, N|T, N|RTT
    ///       a team command (Relay.cs): bot -> N|X|&lt;payload&gt; (G|x|y|z|range: gather); server -> N|X|&lt;char&gt;|&lt;payload&gt;
    ///       the overlay (Overlay.cs): bot -> WIN|&lt;its game window&gt;; server -> KEY|&lt;group name&gt; (PUT /api/cmd?c=key&amp;char=&amp;g=)
    /// Page API (a change needs the header X-PvP: 1, the Host must be 127.0.0.1 / localhost):
    ///   GET /api/state  {"active", "profiles": {id: text}, "bots": {name: state}, "equip": {char: text}}
    ///   GET /api/status {"active", "online", "pages", "pid"}   GET /api/skillnames {id: name}   GET /skillicon/&lt;id&gt;.png
    ///   GET /api/events (server-sent events: state, gone, profiles, equip)
    ///   PUT/DELETE /api/profile?id=   PUT /api/active?id=   PUT /api/cmd?c=statreset | quit (quit: this server stops)
    /// The settings stay in the files (profiles\*.pvp, pvp.ini): the script reads them itself as well.
    /// </summary>
    sealed class PvpServer
    {
        // the ports (PVP_HTTP_PORT / PVP_BOT_PORT override them: a test copy next to the running panel)
        public static readonly int HttpPort = EnvPort("PVP_HTTP_PORT", 7790);
        public static readonly int BotPort = EnvPort("PVP_BOT_PORT", 7791);

        static int EnvPort(string name, int def) =>
            int.TryParse(Environment.GetEnvironmentVariable(name), out var p) && p > 0 && p < 65536 ? p : def;
        const double BotSilentS = 18;           // a bot that sent nothing this long is dropped (hung / the game closed)
        const int StateLineMax = 4 * 1024 * 1024; // a STATE line: 150 players

        static readonly JsonSerializerOptions JsonOpt = new JsonSerializerOptions
        {
            Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,   // the page gets the names as they are
        };
        static readonly byte[] PingMsg = Encoding.ASCII.GetBytes(": ping\n\n");

        sealed class Bot
        {
            public Bot(string name, TcpClient client, NetworkStream stream)
            {
                Name = name;
                Client = client;
                Stream = stream;
            }
            public readonly string Name;
            public readonly TcpClient Client;
            public readonly NetworkStream Stream;
            public readonly SemaphoreSlim WriteLock = new SemaphoreSlim(1, 1);
            public string? State;               // its last STATE json (as it sent it)
            public long Hwnd;                   // its game window (WIN|): the overlay goes over it
            public DateTime StateAt;            // its last STATE came then
            public DateTime At = DateTime.UtcNow;
        }

        sealed class Page
        {
            // a page that does not read (asleep): its messages are dropped, it gets everything again on reconnect
            public readonly Channel<byte[]> Q = Channel.CreateBounded<byte[]>(
                new BoundedChannelOptions(400) { FullMode = BoundedChannelFullMode.DropWrite });
        }

        readonly object _lock = new object();
        readonly Dictionary<string, Bot> _bots = new Dictionary<string, Bot>(StringComparer.Ordinal);
        readonly List<Page> _pages = new List<Page>();
        readonly object _logLock = new object();
        TcpListener? _web, _bot;
        CancellationTokenSource? _cts;
        int _watchSaid = -1;
        string _filesSig = "", _equipSig = "";
        string? _skillNames;
        Dictionary<int, int>? _iconOf;          // skill ID -> its icon: the line of skillicons.txt (from 0)
        string[]? _icons;
        readonly object _iconLock = new object();
        RelayLink? _relay;

        public bool Running { get; private set; }
        public string LastError { get; private set; } = "";

        /// <summary>Bots in / out, the active profile, started / stopped. Raised off the UI thread.</summary>
        public event Action? Changed;

        // ---------- start / stop ----------

        public bool Start()
        {
            if (Running) return true;
            TcpListener? web = null, bot = null;
            try
            {
                Directory.CreateDirectory(Paths.ProfilesDir);
                web = new TcpListener(IPAddress.Loopback, HttpPort) { ExclusiveAddressUse = true };
                bot = new TcpListener(IPAddress.Loopback, BotPort) { ExclusiveAddressUse = true };
                web.Start();
                bot.Start();
            }
            catch (SocketException e)
            {
                try { web?.Stop(); } catch (SocketException) { }
                try { bot?.Stop(); } catch (SocketException) { }
                LastError = "ports " + HttpPort + " / " + BotPort + " are taken (" + e.Message + ")";
                Log("ports " + HttpPort + " / " + BotPort + " taken: " + e.Message);
                return false;
            }
            _web = web;
            _bot = bot;
            _cts = new CancellationTokenSource();
            _watchSaid = -1;
            _filesSig = FilesSig();
            _equipSig = EquipSig();
            LastError = "";
            Running = true;
            var ct = _cts.Token;
            _ = AcceptLoop(web, c => HttpConn(c, ct), ct);
            _ = AcceptLoop(bot, c => BotConn(c, ct), ct);
            _ = WatcherLoop(ct);
            _relay = new RelayLink(ToBotNamed, Log);
            _relay.OnTeamProfile = (from, text) => { TakeTeamProfile(from, text, false); return Task.CompletedTask; };
            _ = _relay.RunAsync(ct);
            Log("PvP server (PvpPanel): page http://127.0.0.1:" + HttpPort + "/  bots 127.0.0.1:" + BotPort + "  folder " + Paths.PvpDir);
            Changed?.Invoke();
            return true;
        }

        public void Stop()
        {
            if (!Running) return;
            Running = false;
            _cts?.Cancel();
            try { _web?.Stop(); } catch (SocketException) { }
            try { _bot?.Stop(); } catch (SocketException) { }
            lock (_lock)
            {
                foreach (var b in _bots.Values) Close(b.Client);
                _bots.Clear();
                foreach (var p in _pages) p.Q.Writer.TryComplete();
                _pages.Clear();
            }
            Log("server stopped");
            Changed?.Invoke();
        }

        static async Task AcceptLoop(TcpListener l, Func<TcpClient, Task> handle, CancellationToken ct)
        {
            while (!ct.IsCancellationRequested)
            {
                TcpClient c;
                try { c = await l.AcceptTcpClientAsync(ct); }
                catch (OperationCanceledException) { break; }
                catch (SocketException) { break; }
                catch (ObjectDisposedException) { break; }
                _ = Task.Run(() => handle(c));
            }
        }

        // ---------- what the tray shows / does ----------

        public ServerStatus Snapshot()
        {
            var st = new ServerStatus { Up = Running, Active = ProfileFiles.Active(), Pid = Environment.ProcessId, Error = LastError };
            lock (_lock)
            {
                st.Online = _bots.Keys.OrderBy(k => k, StringComparer.OrdinalIgnoreCase).ToList();
                foreach (var b in _bots.Values) if (b.Hwnd != 0) st.Windows[b.Name] = b.Hwnd;
                st.Pages = _pages.Count;
            }
            return st;
        }

        public async Task SetActiveAsync(string id)
        {
            ProfileFiles.WriteActive(id);
            Log("active -> " + id);
            if (Running) await ChangedFiles();
        }

        public async Task StatResetAsync()
        {
            await ToBots("STATRESET");
            Log("stats reset");
        }

        // ---------- the bots ----------

        async Task BotConn(TcpClient c, CancellationToken ct)
        {
            string? name = null;
            Bot? me = null;
            var peer = c.Client.RemoteEndPoint?.ToString() ?? "?";
            try
            {
                c.NoDelay = true;
                var s = c.GetStream();
                var rd = new LineReader(s, StateLineMax);
                while (!ct.IsCancellationRequested)
                {
                    var raw = await rd.ReadLineAsync(ct);
                    if (raw == null) break;
                    var line = ProfileFiles.Decode(raw).TrimEnd('\r', '\n');
                    if (line.StartsWith("STATE|", StringComparison.Ordinal) && me != null)
                    {
                        _ = SendTo(me, "K");                                  // its last bytes read: its next line goes at once
                        var json = line.Substring(6);
                        if (!ValidJson(json)) continue;
                        lock (_lock)
                        {
                            if (!_bots.TryGetValue(me.Name, out var b) || b != me) continue;
                            me.State = json;
                            me.At = DateTime.UtcNow;
                            me.StateAt = me.At;
                        }
                        ToPages("state", "{\"name\":" + J(me.Name) + ",\"d\":" + json + "}");
                    }
                    else if (line.StartsWith("HELLO|", StringComparison.Ordinal))
                    {
                        name = line.Substring(6).Trim();
                        if (name.Length == 0) name = "?";
                        var nb = new Bot(name, c, s);
                        Bot? old;
                        lock (_lock)
                        {
                            _bots.TryGetValue(name, out old);
                            _bots[name] = nb;
                        }
                        if (old != null && old.Client != c) Close(old.Client);   // the same character again: the new link
                        me = nb;
                        Log("bot " + name + " in from " + peer);
                        await SendTo(nb, "WATCH|" + WatchNow());              // a page watches now or not
                        if (_relay != null) await _relay.JoinAsync(name);    // assist via the server: in the room
                        Changed?.Invoke();
                    }
                    else if (line.StartsWith("WIN|", StringComparison.Ordinal) && me != null)
                    {
                        if (long.TryParse(line.Substring(4).Trim(), out var hw))
                        {
                            lock (_lock) me.Hwnd = hw;
                            Changed?.Invoke();
                        }
                    }
                    else if (line.StartsWith("N|T|", StringComparison.Ordinal) && me != null)
                    {
                        _ = SendTo(me, "K");
                        if (_relay != null) await _relay.TargetAsync(me.Name, line.Substring(4));   // its target: to the room
                    }
                    else if (line.StartsWith("N|X|", StringComparison.Ordinal) && me != null)
                    {
                        _ = SendTo(me, "K");
                        if (_relay != null) await _relay.ExtraAsync(me.Name, line.Substring(4));   // a team command: to everyone
                    }
                    else if (line == "PONG" && me != null)
                        lock (_lock) me.At = DateTime.UtcNow;
                }
            }
            catch (Exception e) when (e is IOException || e is SocketException || e is OperationCanceledException ||
                                      e is ObjectDisposedException || e is InvalidDataException) { }
            finally
            {
                var removed = false;
                if (me != null)
                    lock (_lock)
                    {
                        if (_bots.TryGetValue(me.Name, out var b) && b == me)
                        {
                            _bots.Remove(me.Name);
                            removed = true;
                        }
                    }
                if (removed && me != null)
                {
                    if (_relay != null) await _relay.LeaveAsync(me.Name);
                    ToPages("gone", "{\"name\":" + J(me.Name) + "}");
                    Log("bot " + me.Name + " out");
                    Changed?.Invoke();
                }
                Close(c);
            }
        }

        static bool ValidJson(string s)
        {
            try
            {
                using var d = JsonDocument.Parse(s);
                return true;
            }
            catch (JsonException) { return false; }
        }

        /// <summary>A line to the bot of this character (the relay's lines); none: nothing.</summary>
        Task ToBotNamed(string name, string line)
        {
            Bot? b;
            lock (_lock) _bots.TryGetValue(name, out b);
            return b == null ? Task.CompletedTask : SendTo(b, line);
        }

        static async Task SendTo(Bot b, string line)
        {
            var data = ProfileFiles.BotBytes(line + "\r\n");
            await b.WriteLock.WaitAsync();
            try
            {
                using var to = new CancellationTokenSource(5000);   // a bot that does not read: dropped, not waited for
                await b.Stream.WriteAsync(data, to.Token);
            }
            catch (Exception e) when (e is IOException || e is OperationCanceledException || e is ObjectDisposedException)
            {
                Close(b.Client);
            }
            finally { b.WriteLock.Release(); }
        }

        async Task ToBots(string line)
        {
            Bot[] all;
            lock (_lock) all = _bots.Values.ToArray();
            await Task.WhenAll(all.Select(b => SendTo(b, line)));
        }

        bool _overlayWatch;

        /// <summary>An overlay shows the bots: they send their state as for an open page.</summary>
        public void SetOverlayWatch(bool on)
        {
            if (_overlayWatch == on) return;
            _overlayWatch = on;
            _ = WatchChanged();
        }

        /// <summary>The overlay: a bot's last state (json) and its age in seconds (null: none).</summary>
        public (string? json, double age) StateOf(string ch)
        {
            lock (_lock)
            {
                var b = _bots.Values.FirstOrDefault(x => string.Equals(x.Name, ch, StringComparison.OrdinalIgnoreCase));
                return b == null || b.State == null ? (null, 1e9) : (b.State, (DateTime.UtcNow - b.StateAt).TotalSeconds);
            }
        }

        /// <summary>The overlay's switch: the profile written, the bots read it (RELOAD), the pages get it.</summary>
        public async Task SaveProfileAsync(string id, string text)
        {
            if (!ProfileFiles.ValidId(id)) return;
            Directory.CreateDirectory(Paths.ProfilesDir);
            ProfileFiles.WriteText(Path.Combine(Paths.ProfilesDir, id + ".pvp"), text);
            await ChangedFiles();
        }

        /// <summary>The overlay's switch: as that group's key pressed on that bot (res-kill / assist on / off).</summary>
        public async Task PressAsync(string ch, string group, bool res = false)
        {
            Bot? b;
            lock (_lock) b = _bots.Values.FirstOrDefault(x => string.Equals(x.Name, ch, StringComparison.OrdinalIgnoreCase));
            if (b != null && group.IndexOfAny(new[] { '\r', '\n', '|' }) < 0) await SendTo(b, "KEY|" + group + (res ? "|res" : ""));
        }

        int WatchNow()
        {
            lock (_lock) return _pages.Count > 0 || _overlayWatch ? 1 : 0;
        }

        /// <summary>The first page opened / the last one closed: the bots start / stop building their state.</summary>
        async Task WatchChanged()
        {
            var w = WatchNow();
            if (w == _watchSaid) return;
            _watchSaid = w;
            int n;
            lock (_lock) n = _pages.Count;
            Log("pages open: " + n + " -> WATCH|" + w);
            await ToBots("WATCH|" + w);
            Changed?.Invoke();
        }

        // ---------- the pages: server-sent events ----------

        void ToPages(string evt, string json)
        {
            var msg = Encoding.UTF8.GetBytes("event: " + evt + "\ndata: " + json + "\n\n");
            lock (_lock)
                foreach (var p in _pages) p.Q.Writer.TryWrite(msg);
        }

        async Task Events(NetworkStream s, CancellationToken ct)
        {
            var p = new Page();
            lock (_lock) _pages.Add(p);
            await WatchChanged();
            using var gone = CancellationTokenSource.CreateLinkedTokenSource(ct);
            try
            {
                var head = Encoding.ASCII.GetBytes("HTTP/1.1 200 OK\r\nContent-Type: text/event-stream; charset=utf-8\r\n" +
                    "Cache-Control: no-store\r\nConnection: keep-alive\r\nX-Accel-Buffering: no\r\n\r\nretry: 1500\n\n");
                await s.WriteAsync(head, ct);
                _ = WatchClose(s, gone);        // the page went away (the panel hid it): noticed at once, not at the next ping
                while (!gone.IsCancellationRequested)
                {
                    byte[] msg;
                    using (var wait = CancellationTokenSource.CreateLinkedTokenSource(gone.Token))
                    {
                        wait.CancelAfter(15000);
                        try { msg = await p.Q.Reader.ReadAsync(wait.Token); }
                        catch (OperationCanceledException) when (!gone.IsCancellationRequested) { msg = PingMsg; }
                    }
                    await s.WriteAsync(msg, gone.Token);
                }
            }
            catch (Exception e) when (e is IOException || e is OperationCanceledException || e is ObjectDisposedException ||
                                      e is ChannelClosedException) { }
            finally
            {
                lock (_lock) _pages.Remove(p);
                try { await WatchChanged(); }
                catch (Exception) { }
            }
        }

        /// <summary>An event stream gets nothing from the page: a read that ends = the page closed the connection.</summary>
        static async Task WatchClose(NetworkStream s, CancellationTokenSource gone)
        {
            var buf = new byte[256];
            try
            {
                while (!gone.IsCancellationRequested)
                    if (await s.ReadAsync(buf, gone.Token) <= 0) break;
            }
            catch (Exception) { }
            try { gone.Cancel(); }
            catch (ObjectDisposedException) { }
        }

        // ---------- the page: a tiny HTTP server ----------

        async Task HttpConn(TcpClient c, CancellationToken ct)
        {
            using (c)
            {
                try
                {
                    var s = c.GetStream();
                    var rd = new LineReader(s, 64 * 1024);
                    string method, target;
                    var headers = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                    byte[] body = Array.Empty<byte>();
                    using (var to = CancellationTokenSource.CreateLinkedTokenSource(ct))
                    {
                        to.CancelAfter(10000);
                        var req = await rd.ReadLineAsync(to.Token);
                        if (req == null) return;
                        var parts = Encoding.Latin1.GetString(req).TrimEnd('\r').Split(' ');
                        if (parts.Length < 3)
                        {
                            await Reply(s, 400, "bad request");
                            return;
                        }
                        method = parts[0];
                        target = parts[1];
                        while (true)
                        {
                            var h = await rd.ReadLineAsync(to.Token);
                            if (h == null) break;
                            var hs = Encoding.Latin1.GetString(h).TrimEnd('\r');
                            if (hs.Length == 0) break;
                            var i = hs.IndexOf(':');
                            if (i > 0) headers[hs.Substring(0, i).Trim()] = hs.Substring(i + 1).Trim();
                        }
                        headers.TryGetValue("content-length", out var cls);
                        if (int.TryParse(cls, out var n) && n > 0 && n < 4_000_000) body = await rd.ReadExactAsync(n, to.Token);
                    }
                    // only this PC by its own name (a site renamed to 127.0.0.1 - DNS rebinding - gets nothing)
                    headers.TryGetValue("host", out var hostH);
                    var host = (hostH ?? "").Split(':')[0].ToLowerInvariant();
                    if (host != "127.0.0.1" && host != "localhost")
                    {
                        await Reply(s, 403, "forbidden");
                        return;
                    }
                    var qi = target.IndexOf('?');
                    var path = qi >= 0 ? target.Substring(0, qi) : target;
                    var q = ParseQuery(qi >= 0 ? target.Substring(qi + 1) : "");
                    q.TryGetValue("id", out var pidQ);
                    var pid = pidQ ?? "";

                    if (method == "GET")
                    {
                        if (path == "/" || path == "/pvp.html" || path == "/index.html")
                        {
                            byte[] page;
                            try { page = File.ReadAllBytes(Paths.Page); }
                            catch (IOException) { await Reply(s, 404, "no pvp.html in " + Paths.PvpDir); return; }
                            await Reply(s, 200, page, "text/html; charset=utf-8");
                            return;
                        }
                        if (path == "/overlay.html")
                        {
                            byte[] ov;
                            try { ov = File.ReadAllBytes(Paths.Overlay); }
                            catch (IOException) { await Reply(s, 404, "no overlay.html in " + Paths.PvpDir); return; }
                            await Reply(s, 200, ov, "text/html; charset=utf-8");
                            return;
                        }
                        if (path == "/api/state") { await Reply(s, 200, StateJson(), "application/json; charset=utf-8"); return; }
                        if (path == "/api/status") { await Reply(s, 200, StatusJson(), "application/json; charset=utf-8"); return; }
                        if (path == "/api/skillnames") { await Reply(s, 200, SkillNamesJson(), "application/json; charset=utf-8"); return; }
                        if (path.StartsWith("/skillicon/", StringComparison.Ordinal))
                        {
                            var ic = SkillIcon(path.Substring(11).Replace(".png", ""));
                            if (ic == null) { await Reply(s, 404, "no icon"); return; }
                            await Reply(s, 200, ic, "image/png", true);
                            return;
                        }
                        if (path == "/api/events") { await Events(s, ct); return; }
                        if (path == "/api/sounds") { await Reply(s, 200, SoundsJson(), "application/json; charset=utf-8"); return; }
                        if (path.StartsWith("/sounds/", StringComparison.Ordinal))
                        {
                            var sn = Uri.UnescapeDataString(path.Substring(8));
                            byte[] snd;
                            try
                            {
                                if (!ValidSound(sn)) throw new FileNotFoundException();
                                snd = File.ReadAllBytes(Path.Combine(Paths.SoundsDir, sn));
                            }
                            catch (IOException) { await Reply(s, 404, "no such sound"); return; }
                            await Reply(s, 200, snd, "audio/wav");
                            return;
                        }
                    }
                    if (method == "PUT" || method == "POST" || method == "DELETE")
                    {
                        headers.TryGetValue("x-pvp", out var xp);
                        if (xp != "1")                  // a plain cross-site form cannot set it
                        {
                            await Reply(s, 403, "forbidden");
                            return;
                        }
                        q.TryGetValue("c", out var cmd);
                        if (path == "/api/profile" && ProfileFiles.ValidId(pid))
                        {
                            var p = Path.Combine(Paths.ProfilesDir, pid + ".pvp");
                            if (method == "DELETE")
                            {
                                try { File.Delete(p); }
                                catch (IOException) { }
                                Log("profile " + pid + " deleted");
                            }
                            else
                            {
                                Directory.CreateDirectory(Paths.ProfilesDir);
                                ProfileFiles.WriteText(p, ProfileFiles.Decode(body));
                            }
                            await ChangedFiles();
                            await Reply(s, 200, "ok");
                            return;
                        }
                        if (path == "/api/sound" && method == "PUT")
                        {
                            q.TryGetValue("name", out var sn);
                            if (!ValidSound(sn ?? "") || !IsWav(body))
                            {
                                await Reply(s, 400, "not a .wav");
                                return;
                            }
                            Directory.CreateDirectory(Paths.SoundsDir);
                            var dst = Path.Combine(Paths.SoundsDir, sn!);
                            File.WriteAllBytes(dst + ".tmp", body);
                            File.Move(dst + ".tmp", dst, true);
                            Log("sound " + sn + " saved, " + body.Length + " bytes");
                            await Reply(s, 200, "ok");
                            return;
                        }
                        if (path == "/api/cmd" && cmd == "statreset")
                        {
                            await StatResetAsync();
                            await Reply(s, 200, "ok");
                            return;
                        }
                        if (path == "/api/cmd" && cmd == "key")   // the overlay: as that group's key pressed on that bot
                        {
                            q.TryGetValue("char", out var kc);
                            q.TryGetValue("g", out var kg);
                            Bot? kb = null;
                            if (kc != null) lock (_lock) kb = _bots.Values.FirstOrDefault(b => string.Equals(b.Name, kc, StringComparison.OrdinalIgnoreCase));
                            if (kb == null || string.IsNullOrWhiteSpace(kg) || kg.IndexOfAny(new[] { '\r', '\n', '|' }) >= 0)
                            {
                                await Reply(s, 400, "no such bot / group");
                                return;
                            }
                            q.TryGetValue("what", out var kw);       // res: the res-kill key of an auto group
                            await SendTo(kb, "KEY|" + kg.Trim() + (kw == "res" ? "|res" : ""));
                            await Reply(s, 200, "ok");
                            return;
                        }
                        if (path == "/api/cmd" && cmd == "lead")    // the Team view: the team leader of the room
                        {
                            q.TryGetValue("name", out var ln);
                            if (_relay != null) await _relay.SetLeadAsync(ln ?? "");
                            Log("team leader: " + (ln ?? "-"));
                            await Reply(s, 200, "ok");
                            return;
                        }
                        if (path == "/api/cmd" && cmd == "teamprof")    // the Team view: the leader's profile to every PC
                        {
                            q.TryGetValue("id", out var tpId);
                            q.TryGetValue("char", out var pch);
                            pch = Regex.Replace(pch ?? "", "[^A-Za-z0-9_-]", "");
                            var src = tpId != null && ProfileFiles.ValidId(tpId) ? ProfileFiles.ReadText(Path.Combine(Paths.ProfilesDir, tpId + ".pvp")) : null;
                            if (src == null || pch.Length == 0)
                            {
                                await Reply(s, 400, "no such profile");
                                return;
                            }
                            var text = TeamText(src, pch, DateTime.Now);
                            TakeTeamProfile(pch, text, true);
                            var sent = _relay != null && _relay.SendProfile(pch, text);
                            await Reply(s, 200, sent ? "sent" : "here only");
                            return;
                        }
                        if (path == "/api/cmd" && cmd == "quit")
                        {
                            Log("quit asked");
                            await Reply(s, 200, "ok");
                            _ = Task.Delay(300).ContinueWith(t => Stop());
                            return;
                        }
                        if (path == "/api/active" && ProfileFiles.ValidId(pid))
                        {
                            await SetActiveAsync(pid);
                            await Reply(s, 200, "ok");
                            return;
                        }
                    }
                    await Reply(s, 404, "not found");
                }
                catch (Exception e) when (e is IOException || e is SocketException || e is OperationCanceledException ||
                                          e is ObjectDisposedException || e is InvalidDataException ||
                                          e is UnauthorizedAccessException) { }
            }
        }

        // ---------- the res-kill sounds: the .wav files of sounds\ (the page lists, plays and adds them) ----------

        static readonly Regex SoundRe = new(@"^[A-Za-z0-9 _\-().\u0400-\u04FF]{1,80}\.wav$", RegexOptions.IgnoreCase);

        static bool ValidSound(string n) => SoundRe.IsMatch(n) && !n.StartsWith('.') && !n.StartsWith(' ') && !n.Contains("..");

        static bool IsWav(byte[] b) => b.Length > 12 && b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F' &&
                                       b[8] == 'W' && b[9] == 'A' && b[10] == 'V' && b[11] == 'E';

        static string SoundsJson()
        {
            try
            {
                var names = Directory.GetFiles(Paths.SoundsDir, "*.wav").Select(f => Path.GetFileName(f))
                    .Where(n => n != null && ValidSound(n)).OrderBy(n => n, StringComparer.OrdinalIgnoreCase).ToList();
                return JsonSerializer.Serialize(names, JsonOpt);
            }
            catch (IOException) { return "[]"; }
        }

        static Task Reply(Stream s, int code, string body, string ctype = "text/plain; charset=utf-8") =>
            Reply(s, code, Encoding.UTF8.GetBytes(body), ctype);

        static async Task Reply(Stream s, int code, byte[] body, string ctype, bool cache = false)
        {
            var reason = code switch { 200 => "OK", 400 => "Bad Request", 403 => "Forbidden", 404 => "Not Found", _ => "Error" };
            var head = "HTTP/1.1 " + code + " " + reason + "\r\nContent-Type: " + ctype + "\r\nContent-Length: " + body.Length +
                       "\r\nCache-Control: " + (cache ? "max-age=86400" : "no-store") + "\r\nConnection: close\r\n\r\n";
            await s.WriteAsync(Encoding.ASCII.GetBytes(head));
            await s.WriteAsync(body);
            await s.FlushAsync();
        }

        static Dictionary<string, string> ParseQuery(string query)
        {
            var d = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (var part in query.Split('&', StringSplitOptions.RemoveEmptyEntries))
            {
                var i = part.IndexOf('=');
                var k = Uri.UnescapeDataString((i >= 0 ? part.Substring(0, i) : part).Replace('+', ' '));
                var v = i >= 0 ? Uri.UnescapeDataString(part.Substring(i + 1).Replace('+', ' ')) : "";
                if (!d.ContainsKey(k)) d[k] = v;     // the first one counts (as parse_qs [0])
            }
            return d;
        }

        // ---------- the JSON the page gets ----------

        static string J(string s) => JsonSerializer.Serialize(s, JsonOpt);
        static string JDict(Dictionary<string, string> d) => JsonSerializer.Serialize(d, JsonOpt);

        const string TeamId = "team";

        /// <summary>The leader's profile as the team one: its name = Team (the leader HH:mm), the same on every PC.</summary>
        static string TeamText(string src, string from, DateTime at)
        {
            var lines = src.Replace("\r\n", "\n").Split('\n').ToList();
            var nm = "name=Team (" + from + " " + at.ToString("HH:mm") + ")";
            int g = lines.FindIndex(l => l.TrimStart().StartsWith("["));
            int k = lines.FindIndex(l => l.TrimStart().StartsWith("name=", StringComparison.OrdinalIgnoreCase));
            if (k >= 0 && (g < 0 || k < g)) lines[k] = nm;
            else lines.Insert(g < 0 ? lines.Count : g, nm);
            return string.Join("\n", lines);
        }

        /// <summary>The team profile (sent from here, or another PC's from the relay): profiles\team.pvp, and the active
        /// one here when it is new (every character without its own profile takes it). The same again: nothing (a PC that
        /// picked another profile keeps it till the leader sends a new one).</summary>
        void TakeTeamProfile(string from, string text, bool mine)
        {
            try
            {
                var path = Path.Combine(Paths.ProfilesDir, TeamId + ".pvp");
                var old = ProfileFiles.ReadText(path);
                if (old != null && old.Replace("\r\n", "\n").TrimEnd() == text.Replace("\r\n", "\n").TrimEnd()) return;
                Directory.CreateDirectory(Paths.ProfilesDir);
                ProfileFiles.WriteText(path, text);
                if (ProfileFiles.Active() != TeamId) ProfileFiles.WriteActive(TeamId);
                Log("team profile from " + from + (mine ? " (sent from here)" : "") + ": the active one now");
            }
            catch (Exception e) when (e is IOException || e is UnauthorizedAccessException)
            {
                Log("team profile from " + from + ": not written (" + e.Message + ")");
            }
        }

        string StateJson()
        {
            var sb = new StringBuilder();
            sb.Append("{\"active\":").Append(J(ProfileFiles.Active()));
            sb.Append(",\"lead\":").Append(J(_relay?.Lead ?? ""));
            sb.Append(",\"profiles\":").Append(JDict(ProfileFiles.ReadAll()));
            sb.Append(",\"bots\":{");
            lock (_lock)
            {
                var first = true;
                foreach (var b in _bots.Values)
                {
                    if (b.State == null) continue;
                    if (!first) sb.Append(',');
                    first = false;
                    sb.Append(J(b.Name)).Append(':').Append(b.State);
                }
            }
            sb.Append("},\"equip\":").Append(JDict(Equip())).Append('}');
            return sb.ToString();
        }

        string StatusJson()
        {
            var st = Snapshot();
            return "{\"active\":" + J(st.Active) + ",\"online\":" + JsonSerializer.Serialize(st.Online, JsonOpt) +
                   ",\"pages\":" + st.Pages + ",\"pid\":" + st.Pid + "}";
        }

        /// <summary>The 16 px icon of a skill (Library\Nav: skilldb.txt field 6 = the line of skillicons.txt), null: none.</summary>
        byte[]? SkillIcon(string idText)
        {
            if (!int.TryParse(idText, out var id)) return null;
            lock (_iconLock)
            {
                if (_iconOf == null)
                {
                    var of = new Dictionary<int, int>();
                    var icons = Array.Empty<string>();
                    try
                    {
                        foreach (var line in File.ReadLines(Paths.SkillDb, Encoding.UTF8))
                        {
                            if (line.StartsWith("#")) continue;
                            var p = line.Split('|');
                            if (p.Length > 6 && int.TryParse(p[0], out var sid) && int.TryParse(p[6].Trim(), out var n)) of[sid] = n;
                        }
                        icons = File.ReadAllLines(Paths.SkillIcons);
                    }
                    catch (IOException) { }
                    catch (UnauthorizedAccessException) { }
                    _iconOf = of;
                    _icons = icons;
                }
                if (!_iconOf.TryGetValue(id, out var k) || _icons == null || k < 0 || k >= _icons.Length) return null;
                try { return Convert.FromBase64String(_icons[k].Trim()); }
                catch (FormatException) { return null; }
            }
        }

        string SkillNamesJson()
        {
            if (_skillNames != null) return _skillNames;
            var names = new Dictionary<string, string>(StringComparer.Ordinal);
            try
            {
                foreach (var line in File.ReadLines(Paths.SkillDb, Encoding.UTF8))
                {
                    if (line.StartsWith("#")) continue;
                    var p = line.Split('|');
                    if (p.Length > 4 && p[0].Length > 0 && p[0].All(char.IsDigit) && p[4].Trim().Length > 0)
                        names[p[0]] = p[4].Trim();
                }
            }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
            _skillNames = JDict(names);
            return _skillNames;
        }

        /// <summary>The equip binds of every character (Library\Binds\&lt;char&gt;.binds): the page warns about the same key.</summary>
        static Dictionary<string, string> Equip()
        {
            var d = new Dictionary<string, string>(StringComparer.Ordinal);
            string[] files;
            try { files = Directory.GetFiles(Paths.BindsDir, "*.binds"); }
            catch (IOException) { return d; }
            catch (UnauthorizedAccessException) { return d; }
            foreach (var f in files)
            {
                var t = ProfileFiles.ReadText(f);
                if (!string.IsNullOrEmpty(t)) d[Path.GetFileNameWithoutExtension(f)] = t;
            }
            return d;
        }

        // ---------- the files: a change (by the page or by hand) -> the bots and the pages ----------

        static string Sig(string folder, string pattern, params string[] extra)
        {
            var sb = new StringBuilder();
            try
            {
                foreach (var f in Directory.GetFiles(folder, pattern).OrderBy(x => x, StringComparer.Ordinal))
                    sb.Append(Path.GetFileName(f)).Append('|').Append(File.GetLastWriteTimeUtc(f).Ticks).Append(';');
            }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
            foreach (var p in extra)
                if (File.Exists(p)) sb.Append(p).Append('|').Append(File.GetLastWriteTimeUtc(p).Ticks).Append(';');
            return sb.ToString();
        }

        static string FilesSig() => Sig(Paths.ProfilesDir, "*.pvp", Paths.Ini);
        static string EquipSig() => Sig(Paths.BindsDir, "*.binds");

        async Task ChangedFiles()
        {
            _filesSig = FilesSig();
            await ToBots("RELOAD");
            ToPages("profiles", "{\"active\":" + J(ProfileFiles.Active()) + ",\"profiles\":" + JDict(ProfileFiles.ReadAll()) + "}");
            Changed?.Invoke();
        }

        async Task WatcherLoop(CancellationToken ct)
        {
            var n = 0;
            while (!ct.IsCancellationRequested)
            {
                try { await Task.Delay(1000, ct); }
                catch (OperationCanceledException) { break; }
                n++;
                try
                {
                    if (FilesSig() != _filesSig)
                    {
                        Log("files changed outside the page");
                        await ChangedFiles();
                    }
                    if (n % 5 != 0) continue;
                    var e = EquipSig();
                    if (e != _equipSig)
                    {
                        _equipSig = e;
                        ToPages("equip", JDict(Equip()));
                    }
                    if (n % 10 == 0) await ToBots("PING");
                    var now = DateTime.UtcNow;
                    Bot[] all;
                    lock (_lock) all = _bots.Values.ToArray();
                    foreach (var b in all)
                        if ((now - b.At).TotalSeconds > BotSilentS) Close(b.Client);
                }
                catch (Exception ex) { Log("watcher: " + ex.Message); }
            }
        }

        // ---------- small things ----------

        static void Close(TcpClient c)
        {
            try { c.Close(); }
            catch (Exception) { }
        }

        void Log(string text)
        {
            lock (_logLock)
            {
                try
                {
                    var f = new FileInfo(Paths.ServerLog);
                    if (f.Exists && f.Length > 512 * 1024) File.Move(f.FullName, f.FullName + ".old", true);
                    File.AppendAllText(Paths.ServerLog, DateTime.Now.ToString("HH:mm:ss ") + text + "\n", Encoding.UTF8);
                }
                catch (IOException) { }
                catch (UnauthorizedAccessException) { }
            }
        }

        /// <summary>Lines of bytes off a stream (up to '\n', without it), and an exact count of bytes after them.</summary>
        sealed class LineReader
        {
            readonly Stream _s;
            readonly int _max;
            readonly byte[] _buf = new byte[65536];
            int _start, _end;

            public LineReader(Stream s, int max)
            {
                _s = s;
                _max = max;
            }

            /// <summary>null = the other side closed.</summary>
            public async Task<byte[]?> ReadLineAsync(CancellationToken ct)
            {
                MemoryStream? acc = null;
                while (true)
                {
                    if (_start < _end)
                    {
                        var i = Array.IndexOf(_buf, (byte)'\n', _start, _end - _start);
                        if (i >= 0)
                        {
                            byte[] line;
                            if (acc == null) line = _buf.AsSpan(_start, i - _start).ToArray();
                            else
                            {
                                acc.Write(_buf, _start, i - _start);
                                line = acc.ToArray();
                            }
                            _start = i + 1;
                            return line;
                        }
                        acc ??= new MemoryStream();
                        acc.Write(_buf, _start, _end - _start);
                        if (acc.Length > _max) throw new InvalidDataException("a line over the limit");
                        _start = _end = 0;
                    }
                    var n = await _s.ReadAsync(_buf.AsMemory(0, _buf.Length), ct);
                    if (n <= 0) return null;
                    _start = 0;
                    _end = n;
                }
            }

            public async Task<byte[]> ReadExactAsync(int count, CancellationToken ct)
            {
                var res = new byte[count];
                var got = Math.Min(count, _end - _start);
                Array.Copy(_buf, _start, res, 0, got);
                _start += got;
                while (got < count)
                {
                    var n = await _s.ReadAsync(res.AsMemory(got, count - got), ct);
                    if (n <= 0) throw new IOException("closed in the body");
                    got += n;
                }
                return res;
            }
        }
    }
}
