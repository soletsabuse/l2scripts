using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading;
using System.Threading.Tasks;

namespace EnchPanel
{
    /// <summary>
    /// The two local engines of the voice (Library\Voice, all on this PC, nothing goes out):
    ///   whisper-server (whisper.cpp, CUDA) + ggml-large-v3-turbo: speech -> text, 127.0.0.1:WhisperPort
    ///   llama-server (llama.cpp, CUDA) + Qwen3-4B-Instruct: a free phrase -> the actions (JSON), 127.0.0.1:LlmPort
    /// Started hidden when the voice is turned on; a Windows job closes them with the panel (a crash too).
    /// </summary>
    sealed class VoiceEngines : IDisposable
    {
        public static readonly int WhisperPort = int.TryParse(Environment.GetEnvironmentVariable("ENCH_WHISPER_PORT"), out var w) && w > 0 ? w : 7781;
        public static readonly int LlmPort = int.TryParse(Environment.GetEnvironmentVariable("ENCH_LLM_PORT"), out var l) && l > 0 ? l : 7782;

        public static string VoiceDir => Path.GetFullPath(Path.Combine(Paths.EnchDir, "..", "Voice"));
        static string WhisperExe => Path.Combine(VoiceDir, "engine", "whisper", "Release", "whisper-server.exe");
        static string LlamaExe => Path.Combine(VoiceDir, "engine", "llama", "llama-server.exe");
        static string WhisperModel => Path.Combine(VoiceDir, "models", "ggml-large-v3-turbo-q8_0.bin");
        static string LlmModel => Path.Combine(VoiceDir, "models", "Qwen3-4B-Instruct-2507-Q6_K.gguf");

        static readonly HttpClient Http = new HttpClient { Timeout = TimeSpan.FromSeconds(150) };   // each call: its own shorter limit

        Process? _whisper, _llm;
        IntPtr _job;
        readonly object _lock = new object();
        readonly Queue<string> _tail = new Queue<string>();   // the engines' last output lines (an error shown)

        /// <summary>off / loading / ready / error</summary>
        public string SttState { get; private set; } = "off";
        public string LlmState { get; private set; } = "off";
        public string Error { get; private set; } = "";

        public static string? Missing()
        {
            foreach (var f in new[] { WhisperExe, LlamaExe, WhisperModel, LlmModel })
                if (!File.Exists(f)) return f;
            return null;
        }

        public async Task StartAsync(bool llm, CancellationToken ct)
        {
            var miss = Missing();
            if (miss != null)
            {
                SttState = LlmState = "error";
                Error = "not found: " + miss;
                return;
            }
            EnsureJob();
            if (_whisper == null || _whisper.HasExited)
            {
                SttState = "loading";
                _whisper = Launch(WhisperExe, "-m \"" + WhisperModel + "\" --host 127.0.0.1 --port " + WhisperPort + " -l ru -t 4 -nt", "whisper");
            }
            if (llm && (_llm == null || _llm.HasExited))
            {
                LlmState = "loading";
                _llm = Launch(LlamaExe, "-m \"" + LlmModel + "\" --host 127.0.0.1 --port " + LlmPort + " -ngl 99 -c 6144 -np 1", "llama");
            }
            var sttTask = WaitUp("http://127.0.0.1:" + WhisperPort + "/", _whisper, s => SttState = s, ct);
            var llmTask = llm ? WaitUp("http://127.0.0.1:" + LlmPort + "/health", _llm, s => LlmState = s, ct) : Task.CompletedTask;
            await Task.WhenAll(sttTask, llmTask);
            // the first use of each is slow (the GPU sets up: whisper took 30 s once) - done now, the state says «загружается»
            if (SttState == "ready")
            {
                SttState = "loading";
                try { await TranscribeAsync(MicRecorder.Wav(new byte[MicRecorder.Rate * 2]), "", ct, 120000); }
                catch (Exception) { }
                SttState = "ready";
            }
            if (llm && LlmState == "ready")
            {
                LlmState = "loading";
                await Warm();
                LlmState = "ready";
            }
        }

        /// <summary>Engines already up on the ports (another panel's; a test): used as they are, nothing started.</summary>
        public async Task<bool> AttachAsync()
        {
            try
            {
                using var a = await Http.GetAsync("http://127.0.0.1:" + WhisperPort + "/");
                using var b = await Http.GetAsync("http://127.0.0.1:" + LlmPort + "/health");
                SttState = a.IsSuccessStatusCode ? "ready" : "error";
                LlmState = b.IsSuccessStatusCode ? "ready" : "error";
                return a.IsSuccessStatusCode && b.IsSuccessStatusCode;
            }
            catch (Exception) { return false; }
        }

        Process? Launch(string exe, string args, string tag)
        {
            try
            {
                var psi = new ProcessStartInfo(exe, args)
                {
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    WorkingDirectory = Path.GetDirectoryName(exe)!,
                };
                var p = Process.Start(psi);
                if (p == null) return null;
                if (_job != IntPtr.Zero) AssignProcessToJobObject(_job, p.Handle);
                p.OutputDataReceived += (s, e) => Tail(tag, e.Data);
                p.ErrorDataReceived += (s, e) => Tail(tag, e.Data);
                p.BeginOutputReadLine();
                p.BeginErrorReadLine();
                return p;
            }
            catch (Exception e)
            {
                Error = tag + " did not start: " + e.Message;
                return null;
            }
        }

        void Tail(string tag, string? line)
        {
            if (string.IsNullOrWhiteSpace(line)) return;
            lock (_lock)
            {
                _tail.Enqueue(tag + ": " + line);
                while (_tail.Count > 60) _tail.Dequeue();
            }
            try { File.AppendAllText(Path.Combine(Paths.LogsDir, "voice_engines.log"), DateTime.Now.ToString("HH:mm:ss ") + tag + ": " + line + "\r\n"); }
            catch (Exception) { }
        }

        public string[] TailLines() { lock (_lock) return _tail.ToArray(); }

        async Task WaitUp(string url, Process? p, Action<string> set, CancellationToken ct)
        {
            var t0 = Stopwatch.StartNew();
            while (!ct.IsCancellationRequested && t0.Elapsed.TotalSeconds < 120)
            {
                if (p == null || p.HasExited)
                {
                    set("error");
                    if (Error.Length == 0) Error = "an engine stopped at the start - see Library\\Logs\\voice_engines.log";
                    return;
                }
                try
                {
                    using var r = await Http.GetAsync(url, ct);
                    if (r.IsSuccessStatusCode)
                    {
                        set("ready");
                        return;
                    }
                }
                catch (HttpRequestException) { }
                catch (TaskCanceledException) { }
                await Task.Delay(300, ct).ContinueWith(_ => { });
            }
            set("error");
            if (Error.Length == 0) Error = "an engine did not get ready in 2 minutes";
        }

        /// <summary>The first request is slow (the GPU warms up): made now, not on the first command.</summary>
        async Task Warm()
        {
            try { await ChatAsync(LlmPrompt.System, "Состояние:\n(пусто)\n\nКоманда: «статус»", LlmPrompt.Schema, 40, CancellationToken.None, 120000); }
            catch (Exception) { }
        }

        public void Stop()
        {
            foreach (var p in new[] { _whisper, _llm })
                try { if (p != null && !p.HasExited) p.Kill(true); }
                catch (Exception) { }
            _whisper = _llm = null;
            SttState = LlmState = "off";
            Error = "";
        }

        public void Dispose()
        {
            Stop();
            if (_job != IntPtr.Zero) CloseHandle(_job);
            _job = IntPtr.Zero;
        }

        // ---------- the calls ----------

        /// <summary>Speech -> text (whisper-server /inference). Prompt: words the speaker uses (better spelling of them).</summary>
        public async Task<string> TranscribeAsync(byte[] wav, string prompt, CancellationToken ct0, int limitMs = 20000)
        {
            using var lim = CancellationTokenSource.CreateLinkedTokenSource(ct0);
            lim.CancelAfter(limitMs);
            var ct = lim.Token;
            using var form = new MultipartFormDataContent();
            var file = new ByteArrayContent(wav);
            file.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("audio/wav");
            form.Add(file, "file", "voice.wav");
            form.Add(new StringContent("json"), "response_format");
            form.Add(new StringContent("0.0"), "temperature");
            form.Add(new StringContent("ru"), "language");
            if (prompt.Length > 0) form.Add(new StringContent(prompt), "prompt");
            using var r = await Http.PostAsync("http://127.0.0.1:" + WhisperPort + "/inference", form, ct);
            var body = await r.Content.ReadAsStringAsync(ct);
            if (!r.IsSuccessStatusCode) throw new IOException("whisper " + (int)r.StatusCode + ": " + body);
            var j = JsonNode.Parse(body);
            return (j?["text"]?.GetValue<string>() ?? "").Trim();
        }

        /// <summary>One chat turn (llama-server, OpenAI style); Schema: the answer forced to that JSON shape.</summary>
        public async Task<string> ChatAsync(string system, string user, JsonNode? schema, int maxTokens, CancellationToken ct0, int limitMs = 30000)
        {
            using var lim = CancellationTokenSource.CreateLinkedTokenSource(ct0);
            lim.CancelAfter(limitMs);
            var ct = lim.Token;
            var req = new JsonObject
            {
                ["messages"] = new JsonArray(
                    new JsonObject { ["role"] = "system", ["content"] = system },
                    new JsonObject { ["role"] = "user", ["content"] = user }),
                ["temperature"] = 0,
                ["max_tokens"] = maxTokens,
                ["cache_prompt"] = true,
            };
            if (schema != null)
                req["response_format"] = new JsonObject { ["type"] = "json_schema", ["json_schema"] = new JsonObject { ["name"] = "actions", ["schema"] = schema.DeepClone() } };   // a copy: a node has one parent
            using var content = new StringContent(req.ToJsonString(), Encoding.UTF8, "application/json");
            using var r = await Http.PostAsync("http://127.0.0.1:" + LlmPort + "/v1/chat/completions", content, ct);
            var body = await r.Content.ReadAsStringAsync(ct);
            if (!r.IsSuccessStatusCode) throw new IOException("llama " + (int)r.StatusCode + ": " + body);
            var j = JsonNode.Parse(body);
            return j?["choices"]?[0]?["message"]?["content"]?.GetValue<string>() ?? "";
        }

        // ---------- the job: the engines die with the panel ----------

        [StructLayout(LayoutKind.Sequential)]
        struct JOBOBJECT_BASIC_LIMIT_INFORMATION
        {
            public long PerProcessUserTimeLimit, PerJobUserTimeLimit;
            public uint LimitFlags;
            public UIntPtr MinimumWorkingSetSize, MaximumWorkingSetSize;
            public uint ActiveProcessLimit;
            public UIntPtr Affinity;
            public uint PriorityClass, SchedulingClass;
        }
        [StructLayout(LayoutKind.Sequential)]
        struct IO_COUNTERS { public ulong a, b, c, d, e, f; }
        [StructLayout(LayoutKind.Sequential)]
        struct JOBOBJECT_EXTENDED_LIMIT_INFORMATION
        {
            public JOBOBJECT_BASIC_LIMIT_INFORMATION BasicLimitInformation;
            public IO_COUNTERS IoInfo;
            public UIntPtr ProcessMemoryLimit, JobMemoryLimit, PeakProcessMemoryUsed, PeakJobMemoryUsed;
        }
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)] static extern IntPtr CreateJobObject(IntPtr a, string? name);
        [DllImport("kernel32.dll")] static extern bool SetInformationJobObject(IntPtr job, int cls, ref JOBOBJECT_EXTENDED_LIMIT_INFORMATION info, int size);
        [DllImport("kernel32.dll")] static extern bool AssignProcessToJobObject(IntPtr job, IntPtr process);
        [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);

        void EnsureJob()
        {
            if (_job != IntPtr.Zero) return;
            _job = CreateJobObject(IntPtr.Zero, null);
            if (_job == IntPtr.Zero) return;
            var info = new JOBOBJECT_EXTENDED_LIMIT_INFORMATION();
            info.BasicLimitInformation.LimitFlags = 0x2000;   // JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
            SetInformationJobObject(_job, 9, ref info, Marshal.SizeOf<JOBOBJECT_EXTENDED_LIMIT_INFORMATION>());
        }
    }
}
