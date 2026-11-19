using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace PvpPanel
{
    /// <summary>
    /// Assist via the server: the link of this PC to the PvP relay (Relay\relay.py on the VPS; relay.ini: host, port,
    /// key, room). One TCP link for every character of this PC. The target of a character here goes to the relay (and
    /// at once to the other characters here: no round trip for them); the targets of the other PCs come from it.
    /// The bots get it all as N|... lines:
    ///   N|LINK|1|&lt;host&gt; / N|LINK|0|&lt;why&gt;   N|ROOM|a,b,c (everyone: the relay's room + the characters here)
    ///   N|T|&lt;char&gt;|&lt;oid&gt;|&lt;name&gt;   N|RTT|&lt;ms&gt; (to the relay and back)
    /// A bot sends N|T|&lt;oid&gt;|&lt;name&gt; when its target changes. No relay.ini / no relay: the characters of this PC
    /// still get each other's targets.
    /// </summary>
    sealed class RelayLink
    {
        const int ConnectMs = 4000, HelloMs = 5000, PingMs = 2000, MaxLine = 1024;

        readonly Func<string, string, Task> _toBot;     // (character, line)
        readonly Action<string> _log;
        readonly object _lock = new object();
        readonly Dictionary<string, string> _local = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);    // lower -> as it is
        readonly Dictionary<string, string> _localT = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);   // char -> "oid|name"
        readonly Dictionary<string, string> _remoteT = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);  // char -> "oid|name" (char as it is: the key)
        List<string> _remoteRoom = new List<string>();
        Channel<string>? _out;          // the lines to the relay while linked
        bool _up;
        string _why = "starting";
        string _host = "";
        int _rtt = -1;
        string _roomSaid = "";

        public RelayLink(Func<string, string, Task> toBot, Action<string> log)
        {
            _toBot = toBot;
            _log = log;
        }

        public bool Up { get { lock (_lock) return _up; } }
        public int Rtt { get { lock (_lock) return _rtt; } }
        public string Why { get { lock (_lock) return _why; } }

        // ---------- the bots of this PC ----------

        /// <summary>A bot said HELLO: in the room; it gets the link, the room and every target now.</summary>
        public async Task JoinAsync(string ch)
        {
            List<string> lines;
            lock (_lock)
            {
                _local[ch] = ch;
                _out?.Writer.TryWrite("JOIN|" + ch);
                if (_localT.TryGetValue(ch, out var t)) _out?.Writer.TryWrite("T|" + ch + "|" + t);
                lines = new List<string> { LinkLine() };
                if (_rtt >= 0) lines.Add("N|RTT|" + _rtt);
                foreach (var kv in _localT) if (!kv.Key.Equals(ch, StringComparison.OrdinalIgnoreCase)) lines.Add("N|T|" + kv.Key + "|" + kv.Value);
                foreach (var kv in _remoteT) if (!_local.ContainsKey(kv.Key)) lines.Add("N|T|" + kv.Key + "|" + kv.Value);
            }
            foreach (var l in lines) await _toBot(ch, l);
            await RoomChanged(true, ch);
        }

        /// <summary>A bot is gone: out of the room.</summary>
        public async Task LeaveAsync(string ch)
        {
            lock (_lock)
            {
                _local.Remove(ch);
                _localT.Remove(ch);
                _out?.Writer.TryWrite("LEAVE|" + ch);
            }
            await RoomChanged(false, null);
        }

        /// <summary>A bot's target changed (its N|T|oid|name): to the relay and to the other characters here.</summary>
        public async Task TargetAsync(string ch, string rest)
        {
            var p = rest.Split('|');
            if (p.Length < 1 || !int.TryParse(p[0], out var oid)) return;
            var name = p.Length > 1 ? Clean(p[1]) : "";
            var t = oid + "|" + name;
            string[] others;
            lock (_lock)
            {
                _localT[ch] = t;
                _out?.Writer.TryWrite("T|" + ch + "|" + t);
                others = _local.Keys.Where(k => !k.Equals(ch, StringComparison.OrdinalIgnoreCase)).ToArray();
            }
            var line = "N|T|" + ch + "|" + t;
            await Task.WhenAll(others.Select(o => _toBot(o, line)));
        }

        static string Clean(string s) => new string(s.Where(c => c != '|' && c != ',' && !char.IsControl(c)).Take(40).ToArray());

        string LinkLine() => _up ? "N|LINK|1|" + _host : "N|LINK|0|" + _why;

        string[] LocalNow() { lock (_lock) return _local.Keys.ToArray(); }

        async Task ToAll(string line) => await Task.WhenAll(LocalNow().Select(c => _toBot(c, line)));

        /// <summary>The room for the bots: the relay's (it has ours too) + the characters here; sent when it changed
        /// (Force: to Only at least).</summary>
        async Task RoomChanged(bool force, string? only)
        {
            string line;
            bool changed;
            lock (_lock)
            {
                var all = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
                if (_up) foreach (var n in _remoteRoom) all.Add(n);
                foreach (var n in _local.Values) all.Add(n);
                line = "N|ROOM|" + string.Join(",", all);
                changed = line != _roomSaid;
                _roomSaid = line;
            }
            if (changed) await ToAll(line);
            else if (force && only != null) await _toBot(only, line);
        }

        async Task SetLink(bool up, string why)
        {
            lock (_lock)
            {
                if (_up == up && _why == why) return;
                _up = up;
                _why = why;
                if (!up)
                {
                    _rtt = -1;
                    _remoteRoom = new List<string>();
                    _remoteT.Clear();
                }
            }
            string line;
            lock (_lock) line = LinkLine();
            await ToAll(line);
            await RoomChanged(false, null);
        }

        // ---------- the relay ----------

        static (string host, int port, string key, string room)? ReadIni()
        {
            var text = ProfileFiles.ReadText(Paths.RelayIni);
            if (text == null) return null;
            string host = "", key = "", room = "main";
            var port = 7795;
            foreach (var raw in text.Split('\n'))
            {
                var l = raw.Trim();
                if (l.Length == 0 || l.StartsWith(";")) continue;
                var i = l.IndexOf('=');
                if (i <= 0) continue;
                var k = l.Substring(0, i).Trim().ToLowerInvariant();
                var v = l.Substring(i + 1).Trim();
                if (k == "host") host = v;
                else if (k == "port" && int.TryParse(v, out var p) && p > 0 && p < 65536) port = p;
                else if (k == "key") key = v;
                else if (k == "room" && v.Length > 0) room = v;
            }
            if (host.Length == 0 || key.Length == 0) return null;
            return (host, port, key, room);
        }

        /// <summary>Linked while the server runs: tried again (2 s, then longer) when the link drops.</summary>
        public async Task RunAsync(CancellationToken ct)
        {
            var wait = 2000;
            string lastLog = "";
            while (!ct.IsCancellationRequested)
            {
                var cfg = ReadIni();
                string why;
                if (cfg == null) why = "no relay.ini (host, key) in the PvP folder";
                else
                {
                    var (host, port, key, room) = cfg.Value;
                    why = await Session(host, port, key, room, ct);
                    if (why == "")                           // it was up: again soon
                    {
                        wait = 2000;
                        why = "the link to the relay dropped";
                    }
                }
                if (ct.IsCancellationRequested) break;
                await SetLink(false, why);
                if (why != lastLog) { _log("relay: " + why); lastLog = why; }
                try { await Task.Delay(wait, ct); } catch (OperationCanceledException) { break; }
                wait = Math.Min(wait * 2, 10000);
            }
        }

        /// <summary>One link to the relay till it drops. "" = it was up, else why it did not come up.</summary>
        async Task<string> Session(string host, int port, string key, string room, CancellationToken ct)
        {
            using var c = new TcpClient();
            try
            {
                using (var to = CancellationTokenSource.CreateLinkedTokenSource(ct))
                {
                    to.CancelAfter(ConnectMs);
                    await c.ConnectAsync(host, port, to.Token);
                }
            }
            catch (OperationCanceledException) { return ct.IsCancellationRequested ? "stopped" : "no answer from " + host + ":" + port; }
            catch (SocketException e) { return "cannot reach " + host + ":" + port + " (" + e.SocketErrorCode + ")"; }
            c.NoDelay = true;
            try { c.Client.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, true); } catch (SocketException) { }
            var s = c.GetStream();
            var rd = new StreamLines(s);
            var outQ = Channel.CreateUnbounded<string>(new UnboundedChannelOptions { SingleReader = true });
            using var life = CancellationTokenSource.CreateLinkedTokenSource(ct);
            try
            {
                await Write(s, "HELLO|" + key + "|" + room + "|1", life.Token);
                string? first;
                using (var to = CancellationTokenSource.CreateLinkedTokenSource(life.Token))
                {
                    to.CancelAfter(HelloMs);
                    first = await rd.ReadLineAsync(to.Token);
                }
                if (first == null) return "the relay closed the link";
                if (first.StartsWith("BYE|")) return "the relay refused: " + first.Substring(4) + " (the key in relay.ini?)";
                if (!first.StartsWith("WELCOME|")) return "not a PvP relay at " + host + ":" + port;
                lock (_lock)
                {
                    _host = host + ":" + port;
                    _out = outQ;
                    foreach (var ch in _local.Values) outQ.Writer.TryWrite("JOIN|" + ch);
                    foreach (var kv in _localT) outQ.Writer.TryWrite("T|" + kv.Key + "|" + kv.Value);
                }
                _log("relay: linked to " + host + ":" + port + ", room " + room);
                await SetLink(true, "");
                var writer = WriterLoop(s, outQ, life.Token);
                var pinger = PingLoop(outQ, life.Token);
                try
                {
                    while (!life.IsCancellationRequested)
                    {
                        var line = await rd.ReadLineAsync(life.Token);
                        if (line == null) break;
                        await FromRelay(line);
                    }
                }
                finally
                {
                    life.Cancel();
                    lock (_lock) { if (_out == outQ) _out = null; }
                    outQ.Writer.TryComplete();
                    try { await Task.WhenAll(writer, pinger); } catch (Exception) { }
                }
                return "";
            }
            catch (OperationCanceledException) { return ct.IsCancellationRequested ? "stopped" : "the relay did not answer"; }
            catch (Exception e) when (e is IOException || e is SocketException || e is InvalidDataException || e is ObjectDisposedException)
            {
                return "the link dropped (" + e.Message + ")";
            }
            finally
            {
                lock (_lock) { if (_out == outQ) _out = null; }
            }
        }

        readonly Stopwatch _clock = Stopwatch.StartNew();

        async Task PingLoop(Channel<string> q, CancellationToken ct)
        {
            try
            {
                while (!ct.IsCancellationRequested)
                {
                    q.Writer.TryWrite("P|" + _clock.ElapsedTicks);
                    await Task.Delay(PingMs, ct);
                }
            }
            catch (OperationCanceledException) { }
        }

        static async Task WriterLoop(Stream s, Channel<string> q, CancellationToken ct)
        {
            try
            {
                await foreach (var line in q.Reader.ReadAllAsync(ct)) await Write(s, line, ct);
            }
            catch (Exception e) when (e is OperationCanceledException || e is IOException || e is ObjectDisposedException) { }
        }

        static async Task Write(Stream s, string line, CancellationToken ct)
        {
            var b = Encoding.UTF8.GetBytes(line + "\n");
            await s.WriteAsync(b, ct);
        }

        async Task FromRelay(string line)
        {
            var i = line.IndexOf('|');
            var kind = i < 0 ? line : line.Substring(0, i);
            var rest = i < 0 ? "" : line.Substring(i + 1);
            if (kind == "P")
            {
                if (long.TryParse(rest, out var t0))
                {
                    var ms = (int)Math.Round((_clock.ElapsedTicks - t0) * 1000.0 / Stopwatch.Frequency);
                    lock (_lock) _rtt = ms;
                    await ToAll("N|RTT|" + ms);
                }
            }
            else if (kind == "ROOM")
            {
                var names = rest.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(n => n.Trim()).Where(n => n.Length > 0).ToList();
                lock (_lock) _remoteRoom = names;
                await RoomChanged(false, null);
            }
            else if (kind == "T")
            {
                var p = rest.Split('|');
                if (p.Length < 2) return;
                var ch = p[0].Trim();
                if (ch.Length == 0 || !int.TryParse(p[1], out var oid)) return;
                var t = oid + "|" + (p.Length > 2 ? Clean(p[2]) : "");
                lock (_lock)
                {
                    if (_local.ContainsKey(ch)) return;          // ours: the bots here have it from us
                    _remoteT[ch] = t;
                }
                await ToAll("N|T|" + ch + "|" + t);
            }
            else if (kind == "BYE")
                throw new IOException("the relay said bye: " + rest);
        }

        /// <summary>Text lines (UTF-8, '\n') off the relay.</summary>
        sealed class StreamLines
        {
            readonly Stream _s;
            readonly byte[] _buf = new byte[8192];
            int _start, _end;

            public StreamLines(Stream s) { _s = s; }

            public async Task<string?> ReadLineAsync(CancellationToken ct)
            {
                var acc = new List<byte>();
                while (true)
                {
                    for (var i = _start; i < _end; i++)
                        if (_buf[i] == (byte)'\n')
                        {
                            acc.AddRange(new ArraySegment<byte>(_buf, _start, i - _start));
                            _start = i + 1;
                            return Encoding.UTF8.GetString(acc.ToArray()).TrimEnd('\r');
                        }
                    acc.AddRange(new ArraySegment<byte>(_buf, _start, _end - _start));
                    if (acc.Count > MaxLine * 64) throw new InvalidDataException("a line too long from the relay");
                    _start = _end = 0;
                    var n = await _s.ReadAsync(_buf.AsMemory(0, _buf.Length), ct);
                    if (n <= 0) return null;
                    _end = n;
                }
            }
        }
    }
}
