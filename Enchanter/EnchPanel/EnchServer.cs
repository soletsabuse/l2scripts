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

namespace EnchPanel
{
    /// <summary>A character the enchanter runs on: its .ench.json (the bot's state) written lately = the bot is on.</summary>
    sealed class CharStatus
    {
        public string Name = "";
        public bool Online;
        public string State = "";      // the run: idle / running / done / stopped
        public string End = "";        // why it ended
        public int Tries, Ok, Broke, Done, DoneMax;
    }

    sealed class EnchStatus
    {
        public bool Up;
        public string Error = "";
        public List<CharStatus> Chars = new List<CharStatus>();
    }

    /// <summary>
    /// The page (enchant.html) and the files of Library\Enchanter over HTTP on 127.0.0.1:7780. The bot (enchant.txt)
    /// works with the files as before: &lt;char&gt;.ench (the settings, the page writes them), &lt;char&gt;.ench.json (its
    /// state), &lt;char&gt;.ench.req (the page asks for the whole bag). The page reads / writes them through here instead
    /// of the browser's folder access:
    ///   GET /                      enchant.html
    ///   GET /api/list              [{"name", "mod" (ms), "size"}] of those files
    ///   GET /api/file?name=        its bytes; X-Mod: its time (ms). 204: none
    ///   PUT /api/file?name=        the body written (a temp file swapped in); answers its time (ms). X-Ench: 1 needed
    ///   GET /api/status            {"pid", "chars": [...]} (what the tray shows)
    /// Only this PC by its own name (the Host header); a change only with X-Ench: 1 (a plain cross-site form cannot set
    /// it).
    /// </summary>
    sealed class EnchServer
    {
        static readonly Regex NameRe = new Regex(@"^[A-Za-z0-9_-]{1,40}\.ench(\.json|\.req)?$", RegexOptions.IgnoreCase);
        const int FreshMs = 6000;      // the bot writes its state every second

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

        static IEnumerable<string> Files()
        {
            string[] all;
            try { all = Directory.GetFiles(Paths.EnchDir); }
            catch (IOException) { yield break; }
            catch (UnauthorizedAccessException) { yield break; }
            foreach (var f in all)
                if (NameRe.IsMatch(Path.GetFileName(f))) yield return f;
        }

        /// <summary>Read while the bot may be writing it: never in its way (it rewrites the state every second).</summary>
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

        /// <summary>A temp file swapped in: the bot never reads half of it; held a moment by the bot: tried again,
        /// then written in place.</summary>
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

        // ---------- what the tray shows ----------

        public EnchStatus Snapshot()
        {
            var st = new EnchStatus { Up = Running, Error = LastError };
            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            foreach (var f in Files().Where(f => f.EndsWith(".ench.json", StringComparison.OrdinalIgnoreCase)).OrderBy(f => f, StringComparer.OrdinalIgnoreCase))
            {
                var name = Path.GetFileName(f);
                var cs = new CharStatus { Name = name.Substring(0, name.Length - ".ench.json".Length) };
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
                            cs.State = Str(run, "state");
                            cs.End = Str(run, "end");
                            cs.Tries = Int(run, "tries");
                            cs.Ok = Int(run, "ok");
                            cs.Broke = Int(run, "broke");
                            cs.Done = Int(run, "done");
                            cs.DoneMax = Int(run, "done_max");
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

        static Encoding? _cp1251;
        /// <summary>The bot's files: utf-8 if it is, else windows-1251.</summary>
        static string DecodeText(byte[] b)
        {
            try { return new UTF8Encoding(false, true).GetString(b); }
            catch (DecoderFallbackException)
            {
                if (_cp1251 == null)
                {
                    Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
                    _cp1251 = Encoding.GetEncoding(1251);
                }
                return _cp1251.GetString(b);
            }
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
                    q.TryGetValue("name", out var fname);
                    fname ??= "";

                    if (method == "GET")
                    {
                        if (path == "/" || path == "/enchant.html" || path == "/index.html")
                        {
                            var page = ReadShared(Paths.Page);
                            if (page == null) { await Reply(s, 404, "no enchant.html in " + Paths.EnchDir); return; }
                            await Reply(s, 200, page, "text/html; charset=utf-8");
                            return;
                        }
                        if (path == "/api/list")
                        {
                            var sb = new StringBuilder("[");
                            foreach (var f in Files())
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
                            sb.Append(']');
                            await Reply(s, 200, sb.ToString(), "application/json; charset=utf-8");
                            return;
                        }
                        if (path == "/api/file")
                        {
                            if (!NameRe.IsMatch(fname)) { await Reply(s, 400, "bad name"); return; }
                            var p = Path.Combine(Paths.EnchDir, fname);
                            long mod = 0;
                            try { if (File.Exists(p)) mod = ModOf(p); }
                            catch (IOException) { }
                            var data = mod > 0 ? ReadShared(p) : null;
                            if (data == null) { await Reply(s, 204, Array.Empty<byte>(), "application/octet-stream"); return; }   // none (no error in the page's console)
                            await Reply(s, 200, data, "application/octet-stream", "X-Mod: " + mod + "\r\n");
                            return;
                        }
                        if (path == "/api/status") { await Reply(s, 200, StatusJson(), "application/json; charset=utf-8"); return; }
                        if (path == "/api/voice")
                        {
                            var hub = VoiceHub.Instance;
                            await Reply(s, 200, hub != null ? hub.StateJson() : "{\"on\":false,\"none\":true}", "application/json; charset=utf-8");
                            return;
                        }
                        if (path == "/favicon.ico") { await Reply(s, 204, Array.Empty<byte>(), "image/x-icon"); return; }
                    }
                    if (method == "PUT" && path == "/api/quit")       // as the tray's Exit (an update swaps the exe, then starts it)
                    {
                        headers.TryGetValue("x-ench", out var xq);
                        if (xq != "1" || Quit == null) { await Reply(s, 403, "forbidden"); return; }
                        await Reply(s, 200, "bye");
                        Quit();
                        return;
                    }
                    if (method == "PUT" && path.StartsWith("/api/voice", StringComparison.Ordinal))
                    {
                        headers.TryGetValue("x-ench", out var xv);
                        var hub = VoiceHub.Instance;
                        if (xv != "1" || hub == null) { await Reply(s, 403, "forbidden"); return; }
                        if (path == "/api/voice")              // ?on=1&key=RControl&mic=-1&llm=1
                        {
                            bool? on = q.TryGetValue("on", out var v1) ? v1 == "1" : null;
                            q.TryGetValue("key", out var key);
                            int? mic = q.TryGetValue("mic", out var v2) && int.TryParse(v2, out var m) ? m : null;
                            bool? llm = q.TryGetValue("llm", out var v3) ? v3 == "1" : null;
                            bool? beeps = q.TryGetValue("beeps", out var v4) ? v4 == "1" : null;
                            hub.Set(on, key, mic, llm, beeps);
                            await Reply(s, 200, hub.StateJson(), "application/json; charset=utf-8");
                            return;
                        }
                        if (path == "/api/voice/text")         // ?text=...&char=<tag>: as if said
                        {
                            q.TryGetValue("text", out var text);
                            q.TryGetValue("char", out var ch);
                            if (string.IsNullOrWhiteSpace(text)) { await Reply(s, 400, "no text"); return; }
                            var e = await hub.HandleText(text.Trim(), 0, 0, null, string.IsNullOrWhiteSpace(ch) ? null : ch);
                            await Reply(s, 200, JsonSerializer.Serialize(new { e.Char, e.Text, e.Via, e.Acts, e.Result, e.Ok, e.LlmMs, e.AllMs }), "application/json; charset=utf-8");
                            return;
                        }
                        if (path == "/api/voice/wav")          // the body: a .wav (a test without the microphone)
                        {
                            var e = await hub.HandleWav(body);
                            if (e == null) { await Reply(s, 503, "speech recognition is not ready"); return; }
                            await Reply(s, 200, JsonSerializer.Serialize(new { e.Char, e.Text, e.Via, e.Acts, e.Result, e.Ok, e.SttMs, e.LlmMs, e.AllMs }), "application/json; charset=utf-8");
                            return;
                        }
                    }
                    if (method == "PUT" && path == "/api/file")
                    {
                        headers.TryGetValue("x-ench", out var xe);
                        if (xe != "1") { await Reply(s, 403, "forbidden"); return; }
                        if (!NameRe.IsMatch(fname) || fname.EndsWith(".json", StringComparison.OrdinalIgnoreCase))
                        {
                            await Reply(s, 400, "bad name");        // the bot's state is the bot's
                            return;
                        }
                        var p = Path.Combine(Paths.EnchDir, fname);
                        try { WriteSwap(p, body); }
                        catch (Exception e) when (e is IOException || e is UnauthorizedAccessException)
                        {
                            await Reply(s, 500, "not written: " + e.Message);
                            return;
                        }
                        await Reply(s, 200, ModOf(p).ToString());
                        return;
                    }
                    await Reply(s, 404, "not found");
                }
                catch (Exception e) when (e is IOException || e is OperationCanceledException || e is ObjectDisposedException ||
                                          e is InvalidDataException || e is SocketException) { }
            }
        }

        string StatusJson()
        {
            var st = Snapshot();
            var sb = new StringBuilder("{\"pid\":").Append(Environment.ProcessId).Append(",\"chars\":[");
            for (int i = 0; i < st.Chars.Count; i++)
            {
                var c = st.Chars[i];
                if (i > 0) sb.Append(',');
                sb.Append("{\"name\":").Append(JsonSerializer.Serialize(c.Name)).Append(",\"online\":").Append(c.Online ? "true" : "false")
                  .Append(",\"state\":").Append(JsonSerializer.Serialize(c.State)).Append('}');
            }
            return sb.Append("]}").ToString();
        }

        static Task Reply(Stream s, int code, string body, string ctype = "text/plain; charset=utf-8") =>
            Reply(s, code, Encoding.UTF8.GetBytes(body), ctype);

        static async Task Reply(Stream s, int code, byte[] body, string ctype, string extra = "")
        {
            var reason = code switch { 200 => "OK", 204 => "No Content", 400 => "Bad Request", 403 => "Forbidden", 404 => "Not Found", _ => "Error" };
            var head = "HTTP/1.1 " + code + " " + reason + "\r\nContent-Type: " + ctype + "\r\nContent-Length: " + body.Length +
                       "\r\nCache-Control: no-store\r\n" + extra + "Connection: close\r\n\r\n";
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
