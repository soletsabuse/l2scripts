using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace PvePanel
{
    /// <summary>A character the farm runs on: its .pve.json (the bot's state) written lately = the bot is on.</summary>
    sealed class CharStatus
    {
        public string Tag = "";        // the file name part
        public string Name = "";
        public bool Online;
        public bool Running;           // farming (not paused)
        public string Phase = "";
        public string What = "";
        public int Kills;
        public int AlertSeq;
        public string Alert = "";
    }

    sealed class PveStatus
    {
        public bool Up;
        public string Error = "";
        public List<CharStatus> Chars = new List<CharStatus>();
    }

    /// <summary>
    /// The pages (pve.html, nav.html) and the files of Library\PvePanel over HTTP on 127.0.0.1:7800. The bot (pve.txt) works
    /// with the files: &lt;char&gt;.pve (the settings, written by the page), &lt;char&gt;.pve.json (its state), Nav\*.navgrid
    /// (the maps), Nav\&lt;char&gt;.navlive (where it is). Only this PC by its own name (the Host header); a change only with
    /// X-Pve: 1 (a plain cross-site form cannot set it). Writes go only into Library\PvePanel.
    ///   GET  /  /nav.html                       the pages
    ///   GET  /api/list                          [{"name","mod","size"}] of the .pve / .pve.json files
    ///   GET  /api/file?name=   PUT (X-Pve)      a .pve / .pve.json file (PUT: .pve only); X-Mod: its time; 204 none
    ///   GET  /api/status                        what the tray shows
    ///   GET  /api/maps                          {"own":[...], "lib":[...], "zones":[...]}: our maps, Library\Nav, Library\Zones
    ///   GET  /api/map?name=&amp;src=own|lib|zone   a map file
    ///   PUT  /api/map?name=X.navgrid            our map written (Nav\X.navgrid)
    ///   PUT  /api/map/import?name=&amp;overwrite=1 Library\Nav\X.navgrid copied into our Nav
    ///   PUT  /api/map/delete?name=              our map removed
    ///   GET  /api/live                          [{"name","mod","text"}] of the fresh Nav\*.navlive
    ///   GET  /api/skills?ids=1,2                [{"id","oper","magic","range","name","icon"}] (data\skilldb.txt, skillicons.txt)
    ///   GET  /api/profiles                      the bot profiles (Library\Configurations\*.xml)
    ///   PUT  /api/quit                          as the tray's Exit (an update swaps the exe, then starts it)
    /// </summary>
    sealed class PveServer
    {
        static readonly Regex CharFileRe = new Regex(@"^[A-Za-z0-9_-]{1,40}\.pve(\.json)?$", RegexOptions.IgnoreCase);
        static readonly Regex OwnMapRe = new Regex(@"^[A-Za-z0-9 _.-]{1,60}\.navgrid$", RegexOptions.IgnoreCase);
        static readonly Regex LibMapRe = new Regex(@"^[A-Za-z0-9 _.-]{1,60}\.(navgrid|navtrace)$", RegexOptions.IgnoreCase);
        static readonly Regex ZoneRe = new Regex(@"^[A-Za-z0-9 _.-]{1,60}\.zmap$", RegexOptions.IgnoreCase);
        static readonly Regex LiveRe = new Regex(@"^[A-Za-z0-9_-]{1,40}\.navlive$", RegexOptions.IgnoreCase);
        static readonly Regex TileRe = new Regex(@"^[0-9]{1,3}_[0-9]{1,3}(_[A-Za-z0-9]{1,8})?\.jpg$", RegexOptions.IgnoreCase);
        const int FreshMs = 6000;              // the bot writes its state every second
        const int LiveFreshMs = 120000;
        const int MaxBody = 32 * 1024 * 1024;  // the biggest maps are ~5 MB

        TcpListener? _web;
        CancellationTokenSource? _cts;
        /// <summary>The tray's Exit (PUT /api/quit), set by the tray.</summary>
        public static Action? Quit;

        public bool Running { get; private set; }
        public string LastError { get; private set; } = "";

        public bool Start()
        {
            if (Running) return true;
            TcpListener? web = null;
            try
            {
                web = new TcpListener(IPAddress.Loopback, Paths.HttpPort) { ExclusiveAddressUse = true };
                web.Start();
            }
            catch (SocketException e)
            {
                try { web?.Stop(); } catch (SocketException) { }
                LastError = "port " + Paths.HttpPort + " is taken (" + e.Message + ")";
                return false;
            }
            _web = web;
            _cts = new CancellationTokenSource();
            LastError = "";
            Running = true;
            var ct = _cts.Token;
            _ = AcceptLoop(web, c => HttpConn(c, ct), ct);
            return true;
        }

        public void Stop()
        {
            if (!Running) return;
            Running = false;
            try { _cts?.Cancel(); } catch (ObjectDisposedException) { }
            try { _web?.Stop(); } catch (SocketException) { }
            _web = null;
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

        // ---------- the files ----------

        static long ModOf(string path) => new DateTimeOffset(File.GetLastWriteTimeUtc(path)).ToUnixTimeMilliseconds();

        static IEnumerable<string> FilesIn(string dir, Regex re)
        {
            string[] all;
            try { all = Directory.GetFiles(dir); }
            catch (IOException) { yield break; }
            catch (UnauthorizedAccessException) { yield break; }
            foreach (var f in all.OrderBy(x => x, StringComparer.OrdinalIgnoreCase))
                if (re.IsMatch(Path.GetFileName(f))) yield return f;
        }

        /// <summary>Read while the bot may be writing it: never in its way.</summary>
        static byte[]? ReadShared(string path)
        {
            for (int i = 0; i < 3; i++)
            {
                try
                {
                    using var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);
                    var ms = new MemoryStream();
                    fs.CopyTo(ms);
                    return ms.ToArray();
                }
                catch (FileNotFoundException) { return null; }
                catch (DirectoryNotFoundException) { return null; }
                catch (IOException) { Thread.Sleep(30); }
                catch (UnauthorizedAccessException) { return null; }
            }
            return null;
        }

        /// <summary>A temp file swapped in: the bot never reads half of it; held a moment by the bot: tried again, then
        /// written in place.</summary>
        public static void WriteSwap(string path, byte[] data)
        {
            var tmp = path + ".tmp";
            File.WriteAllBytes(tmp, data);
            for (int i = 0; i < 20; i++)
            {
                try
                {
                    File.Move(tmp, path, true);
                    return;
                }
                catch (IOException) { Thread.Sleep(50); }
                catch (UnauthorizedAccessException) { Thread.Sleep(50); }
            }
            File.WriteAllBytes(path, data);
            try { File.Delete(tmp); }
            catch (IOException) { }
        }

        static Encoding? _cp1251;
        static Encoding Cp1251
        {
            get
            {
                if (_cp1251 == null)
                {
                    Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
                    _cp1251 = Encoding.GetEncoding(1251);
                }
                return _cp1251;
            }
        }

        /// <summary>The bot's files: utf-8 if it is, else windows-1251.</summary>
        static string DecodeText(byte[] b)
        {
            try { return new UTF8Encoding(false, true).GetString(b); }
            catch (DecoderFallbackException) { return Cp1251.GetString(b); }
        }

        static string FileListJson(IEnumerable<string> files)
        {
            var sb = new StringBuilder("[");
            foreach (var f in files)
            {
                long mod, size;
                try
                {
                    mod = ModOf(f);
                    size = new FileInfo(f).Length;
                }
                catch (IOException) { continue; }
                if (sb.Length > 1) sb.Append(',');
                sb.Append("{\"name\":").Append(JsonSerializer.Serialize(Path.GetFileName(f)))
                  .Append(",\"mod\":").Append(mod).Append(",\"size\":").Append(size).Append('}');
            }
            return sb.Append(']').ToString();
        }

        // ---------- the skill data (data\skilldb.txt: id|oper|magic|range|name|lvl:range,...|icon line) ----------

        sealed class SkillInfo
        {
            public int Oper, Magic, Range, Icon = -1;
            public string Name = "";
        }

        static Dictionary<int, SkillInfo>? _skills;
        static string[]? _icons;
        static readonly object SkillLock = new object();

        static void LoadSkillData()
        {
            lock (SkillLock)
            {
                if (_skills != null) return;
                var d = new Dictionary<int, SkillInfo>();
                try
                {
                    foreach (var line in File.ReadLines(Path.Combine(Paths.DataDir, "skilldb.txt")))
                    {
                        if (line.Length == 0 || line[0] == '#') continue;
                        var f = line.Split('|');
                        if (f.Length < 7 || !int.TryParse(f[0], out var id)) continue;
                        var si = new SkillInfo { Name = f[4] };
                        int.TryParse(f[1], out si.Oper);
                        int.TryParse(f[2], out si.Magic);
                        int.TryParse(f[3], out si.Range);
                        if (int.TryParse(f[6], out var ic)) si.Icon = ic;
                        d[id] = si;
                    }
                }
                catch (IOException) { }
                try { _icons = File.ReadAllLines(Path.Combine(Paths.DataDir, "skillicons.txt")); }
                catch (IOException) { _icons = Array.Empty<string>(); }
                _skills = d;
            }
        }

        static string SkillsJson(string ids)
        {
            LoadSkillData();
            var sb = new StringBuilder("[");
            foreach (var part in ids.Split(',', StringSplitOptions.RemoveEmptyEntries).Take(600))
            {
                if (!int.TryParse(part, out var id) || _skills == null || !_skills.TryGetValue(id, out var s)) continue;
                var icon = s.Icon >= 0 && _icons != null && s.Icon < _icons.Length ? _icons[s.Icon].Trim() : "";
                if (sb.Length > 1) sb.Append(',');
                sb.Append("{\"id\":").Append(id).Append(",\"oper\":").Append(s.Oper).Append(",\"magic\":").Append(s.Magic)
                  .Append(",\"range\":").Append(s.Range).Append(",\"name\":").Append(JsonSerializer.Serialize(s.Name))
                  .Append(",\"icon\":").Append(JsonSerializer.Serialize(icon)).Append('}');
            }
            return sb.Append(']').ToString();
        }

        // ---------- what the tray shows ----------

        public PveStatus Snapshot()
        {
            var st = new PveStatus { Up = Running, Error = LastError };
            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            foreach (var f in FilesIn(Paths.PveDir, CharFileRe).Where(f => f.EndsWith(".pve.json", StringComparison.OrdinalIgnoreCase)))
            {
                var name = Path.GetFileName(f);
                var cs = new CharStatus { Tag = name.Substring(0, name.Length - ".pve.json".Length) };
                cs.Name = cs.Tag;
                long mod;
                try { mod = ModOf(f); }
                catch (IOException) { continue; }
                cs.Online = now - mod < FreshMs;
                var data = ReadShared(f);
                if (data != null)
                {
                    try
                    {
                        using var doc = JsonDocument.Parse(DecodeText(data));
                        var root = doc.RootElement;
                        if (root.TryGetProperty("char", out var ch) && ch.ValueKind == JsonValueKind.String) cs.Name = ch.GetString() ?? cs.Name;
                        if (root.TryGetProperty("run", out var run) && run.ValueKind == JsonValueKind.Object)
                        {
                            cs.Running = run.TryGetProperty("on", out var on) && on.ValueKind == JsonValueKind.True;
                            cs.Phase = Str(run, "phase");
                            cs.What = Str(run, "what");
                            cs.Kills = Int(run, "kills");
                            cs.AlertSeq = Int(run, "alert_seq");
                            cs.Alert = Str(run, "alert");
                        }
                    }
                    catch (JsonException) { }          // caught mid-write: the next time
                }
                st.Chars.Add(cs);
            }
            return st;
        }

        static string Str(JsonElement e, string k) => e.TryGetProperty(k, out var v) && v.ValueKind == JsonValueKind.String ? v.GetString() ?? "" : "";
        static int Int(JsonElement e, string k) => e.TryGetProperty(k, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out var n) ? n : 0;

        string StatusJson()
        {
            var st = Snapshot();
            var sb = new StringBuilder("{\"pid\":").Append(Environment.ProcessId).Append(",\"dir\":").Append(JsonSerializer.Serialize(Paths.PveDir))
              .Append(",\"chars\":[");
            for (int i = 0; i < st.Chars.Count; i++)
            {
                var c = st.Chars[i];
                if (i > 0) sb.Append(',');
                sb.Append("{\"tag\":").Append(JsonSerializer.Serialize(c.Tag)).Append(",\"name\":").Append(JsonSerializer.Serialize(c.Name))
                  .Append(",\"online\":").Append(c.Online ? "true" : "false").Append(",\"running\":").Append(c.Running ? "true" : "false")
                  .Append(",\"phase\":").Append(JsonSerializer.Serialize(c.Phase)).Append('}');
            }
            return sb.Append("]}").ToString();
        }

        // ---------- the pages: a tiny HTTP server ----------

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
                        to.CancelAfter(30000);
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
                        if (int.TryParse(cls, out var n) && n > 0)
                        {
                            if (n > MaxBody)
                            {
                                await Reply(s, 400, "too big");
                                return;
                            }
                            body = await rd.ReadExactAsync(n, to.Token);
                        }
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
                    q.TryGetValue("name", out var fname);
                    fname ??= "";
                    headers.TryGetValue("x-pve", out var xpve);
                    var mayWrite = xpve == "1";

                    if (method == "GET") await Get(s, path, q, fname);
                    else if (method == "PUT")
                    {
                        if (!mayWrite)
                        {
                            await Reply(s, 403, "forbidden");
                            return;
                        }
                        await Put(s, path, q, fname, body);
                    }
                    else await Reply(s, 404, "not found");
                }
                catch (Exception e) when (e is IOException || e is OperationCanceledException || e is ObjectDisposedException ||
                                          e is InvalidDataException || e is SocketException) { }
            }
        }

        async Task Get(Stream s, string path, Dictionary<string, string> q, string fname)
        {
            if (path == "/" || path == "/pve.html" || path == "/index.html" || path == "/nav.html")
            {
                var file = path == "/nav.html" ? Paths.NavPage : Paths.Page;
                var page = ReadShared(file);
                if (page == null) { await Reply(s, 404, "no " + Path.GetFileName(file) + " in " + Paths.PveDir); return; }
                await Reply(s, 200, page, "text/html; charset=utf-8");
                return;
            }
            switch (path)
            {
                case "/api/list":
                    await Reply(s, 200, FileListJson(FilesIn(Paths.PveDir, CharFileRe)), "application/json; charset=utf-8");
                    return;
                case "/api/file":
                {
                    if (!CharFileRe.IsMatch(fname)) { await Reply(s, 400, "bad name"); return; }
                    await SendFile(s, Path.Combine(Paths.PveDir, fname));
                    return;
                }
                case "/api/status":
                    await Reply(s, 200, StatusJson(), "application/json; charset=utf-8");
                    return;
                case "/api/maps":
                {
                    var own = FileListJson(FilesIn(Paths.NavDir, OwnMapRe));
                    var lib = FileListJson(FilesIn(Paths.LibNavDir, LibMapRe));
                    var zones = FileListJson(FilesIn(Paths.ZonesDir, ZoneRe));
                    await Reply(s, 200, "{\"own\":" + own + ",\"lib\":" + lib + ",\"zones\":" + zones + "}", "application/json; charset=utf-8");
                    return;
                }
                case "/api/map":
                {
                    q.TryGetValue("src", out var src);
                    string? p = (src ?? "own") switch
                    {
                        "own" when OwnMapRe.IsMatch(fname) => Path.Combine(Paths.NavDir, fname),
                        "lib" when LibMapRe.IsMatch(fname) => Path.Combine(Paths.LibNavDir, fname),
                        "zone" when ZoneRe.IsMatch(fname) => Path.Combine(Paths.ZonesDir, fname),
                        _ => null,
                    };
                    if (p == null) { await Reply(s, 400, "bad name"); return; }
                    await SendFile(s, p);
                    return;
                }
                case "/api/live":
                {
                    var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
                    var sb = new StringBuilder("[");
                    foreach (var f in FilesIn(Paths.NavDir, LiveRe))
                    {
                        long mod;
                        try { mod = ModOf(f); }
                        catch (IOException) { continue; }
                        if (now - mod > LiveFreshMs) continue;
                        var data = ReadShared(f);
                        if (data == null) continue;
                        if (sb.Length > 1) sb.Append(',');
                        sb.Append("{\"name\":").Append(JsonSerializer.Serialize(Path.GetFileName(f))).Append(",\"mod\":").Append(mod)
                          .Append(",\"text\":").Append(JsonSerializer.Serialize(DecodeText(data))).Append('}');
                    }
                    await Reply(s, 200, sb.Append(']').ToString(), "application/json; charset=utf-8");
                    return;
                }
                case "/api/skills":
                {
                    q.TryGetValue("ids", out var ids);
                    await Reply(s, 200, SkillsJson(ids ?? ""), "application/json; charset=utf-8");
                    return;
                }
                case "/api/profiles":
                {
                    var names = FilesIn(Paths.ProfilesDir, new Regex(@"^[^\\/]{1,80}\.xml$", RegexOptions.IgnoreCase)).Select(Path.GetFileName);
                    await Reply(s, 200, JsonSerializer.Serialize(names), "application/json; charset=utf-8");
                    return;
                }
                case "/favicon.ico":
                    await Reply(s, 204, Array.Empty<byte>(), "image/x-icon");
                    return;
            }
            // the game map tiles under the editor (c:\games\andruxa\Maps\<x>_<y>[_<level>].jpg, read only)
            if (path.StartsWith("/tiles/", StringComparison.Ordinal))
            {
                var tn = path.Substring(7);
                if (!TileRe.IsMatch(tn)) { await Reply(s, 400, "bad name"); return; }
                var data = ReadShared(Path.Combine(Paths.TilesDir, tn));
                if (data == null) { await Reply(s, 404, "no tile"); return; }
                await Reply(s, 200, data, "image/jpeg", "", true);
                return;
            }
            await Reply(s, 404, "not found");
        }

        async Task Put(Stream s, string path, Dictionary<string, string> q, string fname, byte[] body)
        {
            switch (path)
            {
                case "/api/quit":
                    if (Quit == null) { await Reply(s, 403, "forbidden"); return; }
                    await Reply(s, 200, "bye");
                    Quit();
                    return;
                case "/api/file":
                {
                    if (!CharFileRe.IsMatch(fname) || fname.EndsWith(".json", StringComparison.OrdinalIgnoreCase))
                    {
                        await Reply(s, 400, "bad name");       // the bot's state is the bot's
                        return;
                    }
                    await WriteTo(s, Path.Combine(Paths.PveDir, fname), body);
                    return;
                }
                case "/api/map":
                {
                    if (!OwnMapRe.IsMatch(fname)) { await Reply(s, 400, "bad name"); return; }
                    if (body.Length < 10 || !DecodeText(body.Take(4096).ToArray()).Contains("\nG ") && !DecodeText(body.Take(4096).ToArray()).StartsWith("G "))
                    {
                        await Reply(s, 400, "not a navgrid");
                        return;
                    }
                    Paths.EnsureFolders();
                    await WriteTo(s, Path.Combine(Paths.NavDir, fname), body);
                    return;
                }
                case "/api/map/import":
                {
                    if (!OwnMapRe.IsMatch(fname)) { await Reply(s, 400, "bad name"); return; }
                    var from = Path.Combine(Paths.LibNavDir, fname);
                    var to = Path.Combine(Paths.NavDir, fname);
                    if (!File.Exists(from)) { await Reply(s, 404, "no " + fname + " in Library\\Nav"); return; }
                    if (File.Exists(to) && !(q.TryGetValue("overwrite", out var ow) && ow == "1")) { await Reply(s, 409, "exists"); return; }
                    var data = ReadShared(from);
                    if (data == null) { await Reply(s, 500, "not read"); return; }
                    Paths.EnsureFolders();
                    await WriteTo(s, to, data);
                    return;
                }
                case "/api/map/delete":
                {
                    if (!OwnMapRe.IsMatch(fname)) { await Reply(s, 400, "bad name"); return; }
                    var p = Path.Combine(Paths.NavDir, fname);
                    try
                    {
                        if (File.Exists(p)) File.Delete(p);
                        var cache = Path.Combine(Paths.NavDir, "cache", fname + ".navcache");
                        if (File.Exists(cache)) File.Delete(cache);
                    }
                    catch (Exception e) when (e is IOException || e is UnauthorizedAccessException)
                    {
                        await Reply(s, 500, "not removed: " + e.Message);
                        return;
                    }
                    await Reply(s, 200, "ok");
                    return;
                }
            }
            await Reply(s, 404, "not found");
        }

        static async Task SendFile(Stream s, string p)
        {
            long mod = 0;
            try { if (File.Exists(p)) mod = ModOf(p); }
            catch (IOException) { }
            var data = mod > 0 ? ReadShared(p) : null;
            if (data == null) { await Reply(s, 204, Array.Empty<byte>(), "application/octet-stream"); return; }   // none (no error in the console)
            await Reply(s, 200, data, "application/octet-stream", "X-Mod: " + mod + "\r\n");
        }

        static async Task WriteTo(Stream s, string p, byte[] body)
        {
            try { WriteSwap(p, body); }
            catch (Exception e) when (e is IOException || e is UnauthorizedAccessException)
            {
                await Reply(s, 500, "not written: " + e.Message);
                return;
            }
            await Reply(s, 200, ModOf(p).ToString());
        }

        static Task Reply(Stream s, int code, string body, string ctype = "text/plain; charset=utf-8") =>
            Reply(s, code, Encoding.UTF8.GetBytes(body), ctype);

        static async Task Reply(Stream s, int code, byte[] body, string ctype, string extra = "", bool cache = false)
        {
            var reason = code switch { 200 => "OK", 204 => "No Content", 400 => "Bad Request", 403 => "Forbidden", 404 => "Not Found", 409 => "Conflict", _ => "Error" };
            var head = "HTTP/1.1 " + code + " " + reason + "\r\nContent-Type: " + ctype + "\r\nContent-Length: " + body.Length +
                       (cache ? "\r\nCache-Control: max-age=86400\r\n" : "\r\nCache-Control: no-store\r\n") + extra + "Connection: close\r\n\r\n";
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
                if (!d.ContainsKey(k)) d[k] = v;
            }
            return d;
        }

        /// <summary>Lines (and then a body) off a stream.</summary>
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
