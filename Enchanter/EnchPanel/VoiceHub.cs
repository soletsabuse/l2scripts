using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Threading;

namespace EnchPanel
{
    /// <summary>
    /// The voice control of the enchanter. Hold the key (any window, the game too), say it, let go:
    ///   the take -> whisper (text) -> the fast rules, else the local model (actions) -> the character's .ench edited
    ///   (the character: the one whose game window was in front) -> a tone + a line over the game + the page's log.
    /// Settings in ench_panel.ini: voice_on, voice_key, voice_mic, voice_llm.
    /// </summary>
    sealed class VoiceHub : IDisposable
    {
        public static VoiceHub? Instance;

        readonly Dispatcher _ui;
        readonly VoiceEngines _eng = new VoiceEngines();
        readonly MicRecorder _mic = new MicRecorder();
        readonly SemaphoreSlim _busy = new SemaphoreSlim(1, 1);
        readonly object _lock = new object();
        readonly List<LogEntry> _log = new List<LogEntry>();
        CancellationTokenSource? _cts;
        Thread? _ptt;
        volatile bool _pttRun;
        VoiceHud? _hud;
        int _seq;
        (string Tag, List<VAct> Acts, DateTime Until)? _ask;   // «кристаллизовать?» / «удалить?» waits for «да»
        int _uiSeq;                                     // the page: a tab / a character to show (its poll takes it)
        string _uiTab = "", _uiChar = "";
        /// <summary>The tray's: the panel window brought up (an «открой ...» command).</summary>
        public Action? ShowPanel;

        public sealed class LogEntry
        {
            public int N;
            public string T = "", Char = "", Text = "", Via = "", Acts = "", Result = "";
            public bool Ok;
            public long SttMs, LlmMs, AllMs;
        }

        public VoiceHub(Dispatcher ui)
        {
            _ui = ui;
            Instance = this;
        }

        public bool On => PanelSettings.GetBool("voice_on", false);
        public bool UseLlm => PanelSettings.GetBool("voice_llm", true);
        public string Key => PanelSettings.GetStr("voice_key", "RControl");
        public int MicIndex => (int)PanelSettings.GetNum("voice_mic", -1);
        /// <summary>The tones (key held / done / failed): off unless turned on - the line over the game says it all.</summary>
        public bool Sounds => PanelSettings.GetBool("voice_beeps", false);
        const int HoldMs = 300;                // the key held this long: a voice take (a shorter tap is the game's)

        public void Start()
        {
            if (!On) return;
            _cts?.Cancel();
            _cts = new CancellationTokenSource();
            var ct = _cts.Token;
            _ = Task.Run(() => _eng.StartAsync(UseLlm, ct));
            if (!_mic.IsOpen) _mic.Open(MicIndex);
            if (_ptt == null)
            {
                _pttRun = true;
                _ptt = new Thread(PttLoop) { IsBackground = true, Name = "voice key" };
                _ptt.Start();
            }
        }

        /// <summary>A test: the engines another panel runs (nothing started here).</summary>
        public Task<bool> AttachEngines() => _eng.AttachAsync();

        public void Stop()
        {
            _cts?.Cancel();
            _pttRun = false;
            _ptt?.Join(300);
            _ptt = null;
            _mic.Close();
            _eng.Stop();
        }

        public void Set(bool? on, string? key, int? mic, bool? llm, bool? beeps = null)
        {
            bool restart = false;
            if (beeps != null) PanelSettings.SetBool("voice_beeps", beeps.Value);
            if (key != null && KeyVk(key) != 0) PanelSettings.SetStr("voice_key", key);
            if (mic != null && mic.Value != MicIndex) { PanelSettings.SetNums(("voice_mic", mic.Value)); if (_mic.IsOpen) _mic.Open(mic.Value); }
            if (llm != null && llm.Value != UseLlm) { PanelSettings.SetBool("voice_llm", llm.Value); restart = On; }
            if (on != null && on.Value != On)
            {
                PanelSettings.SetBool("voice_on", on.Value);
                if (on.Value) Start(); else Stop();
                return;
            }
            if (restart)
            {
                Stop();
                Start();
            }
        }

        public void Dispose()
        {
            Stop();
            _eng.Dispose();
            _ui.BeginInvoke(new Action(() => _hud?.Close()));
        }

        // ---------- the key: held = recording ----------

        [DllImport("user32.dll")] static extern short GetAsyncKeyState(int vKey);
        [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();

        /// <summary>Another key / mouse button pressed now (not the voice key, not its Ctrl / Shift / Alt twin, not one held
        /// already at the press): a game combo (Ctrl+click...), not a voice take.</summary>
        static bool OtherKeyNow(int vk, bool[] downAtStart)
        {
            for (int k = 1; k < 255; k++)
            {
                if (k == vk || downAtStart[k]) continue;
                if ((vk == 0xA2 || vk == 0xA3) && (k == 0x11 || k == 0xA2 || k == 0xA3)) continue;
                if ((vk == 0xA0 || vk == 0xA1) && (k == 0x10 || k == 0xA0 || k == 0xA1)) continue;
                if ((vk == 0xA4 || vk == 0xA5) && (k == 0x12 || k == 0xA4 || k == 0xA5)) continue;
                if ((GetAsyncKeyState(k) & 0x8000) != 0) return true;
            }
            return false;
        }

        void PttLoop()
        {
            bool was = false, live = false, cancelled = false;
            long fg = 0;
            var held = Stopwatch.StartNew();
            var downAtStart = new bool[256];
            while (_pttRun)
            {
                int vk = KeyVk(Key);
                bool down = vk != 0 && (GetAsyncKeyState(vk) & 0x8000) != 0;
                if (down && !was)
                {
                    // pressed: the take starts silently - a tap of a game key (Ctrl...) is no voice, says nothing
                    fg = GetForegroundWindow().ToInt64();
                    held.Restart();
                    live = false;
                    cancelled = false;
                    for (int k = 1; k < 256; k++) downAtStart[k] = (GetAsyncKeyState(k) & 0x8000) != 0;
                    _mic.Begin();
                }
                else if (down && was && !cancelled)
                {
                    if (OtherKeyNow(vk, downAtStart))
                    {
                        cancelled = true;                 // a game combo: dropped without a word
                        _mic.End();
                        if (live) Hud("отменено: нажата ещё клавиша", HudKind.Busy, 900, fg);
                    }
                    else if (!live && held.ElapsedMilliseconds >= HoldMs)
                    {
                        live = true;
                        if (Sounds) Beeps.Start();
                        Hud("● говори…", HudKind.Rec, 15000, fg);
                    }
                    else if (held.ElapsedMilliseconds > 15000)
                    {
                        cancelled = true;                 // a stuck key: given up
                        _mic.End();
                        Hud("клавиша держится больше 15 с — отпусти", HudKind.Fail, 2000, fg);
                    }
                }
                else if (!down && was && !cancelled)
                {
                    var pcm = _mic.End();
                    if (live && pcm != null && pcm.Length >= MicRecorder.Rate * 2 / 4)
                    {
                        var f = fg;
                        _ = Task.Run(() => HandleAudio(pcm, f));
                    }
                    else if (live) Hud("слишком коротко", HudKind.Busy, 900, fg);
                }
                was = down;
                Thread.Sleep(10);
            }
        }

        // ---------- the pipeline ----------

        const string SttPrompt = "Команды заточки: старт, стоп, заточи до плюс шести, с плюс трёх, свиток брони А, свиток оружия Б, благословенный свиток, " +
                                 "камни выключи, кристаллизуй, пауза, новый диапазон, второй диапазон, кольца, серьги, ожерелье, бижа, сет, " +
                                 "открой настройки, открой историю, выбери персонажа, статус.";

        async Task HandleAudio(byte[] pcm, long fg)
        {
            var all = Stopwatch.StartNew();
            if (_eng.SttState != "ready")
            {
                Hud(_eng.SttState == "loading" ? "голос ещё загружается…" : "распознавание не работает: " + _eng.Error, HudKind.Fail, 2500, fg);
                if (Sounds) Beeps.Fail();
                return;
            }
            Hud("… распознаю", HudKind.Busy, 8000, fg);
            string text;
            var sw = Stopwatch.StartNew();
            try { text = await _eng.TranscribeAsync(MicRecorder.Wav(pcm), SttPrompt, CancellationToken.None); }
            catch (Exception e)
            {
                Hud("ошибка распознавания: " + e.Message, HudKind.Fail, 3000, fg);
                if (Sounds) Beeps.Fail();
                return;
            }
            long stt = sw.ElapsedMilliseconds;
            text = CleanStt(text);
            if (text.Length == 0)
            {
                Hud("ничего не услышал", HudKind.Busy, 1200, fg);
                AddLog(new LogEntry { Text = "", Via = "—", Result = "тишина", SttMs = stt, AllMs = all.ElapsedMilliseconds });
                return;
            }
            await HandleText(text, fg, stt, all);
        }

        /// <summary>whisper's stock phrases on noise / silence: dropped.</summary>
        static string CleanStt(string t)
        {
            t = t.Trim().Trim('"', '«', '»', '[', ']', '(', ')');
            var low = t.ToLowerInvariant();
            if (low.Contains("субтитры") || low.Contains("продолжение следует") || low.Contains("спасибо за просмотр") || low.Contains("редактор субтитров")) return "";
            return t;
        }

        /// <summary>A phrase (spoken, or typed on the page: the same path).</summary>
        public async Task<LogEntry> HandleText(string text, long fg, long sttMs, Stopwatch? all = null, string? forceTag = null)
        {
            all ??= Stopwatch.StartNew();
            await _busy.WaitAsync();
            try
            {
                var e = new LogEntry { Text = text, SttMs = sttMs };
                string why = "";
                var c = forceTag != null ? CharCtx.All().FirstOrDefault(x => x.Tag.Equals(forceTag, StringComparison.OrdinalIgnoreCase)) : CharCtx.Pick(fg, out why);
                if (c == null && forceTag != null) why = "нет персонажа " + forceTag;
                if (c == null)
                {
                    e.Result = why;
                    Finish(e, false, fg, all);
                    return e;
                }
                e.Char = c.Name;
                c.Doc = EnchDoc.Load(c.EnchPath);

                var acts = FastParse.Parse(text);
                string say = "";
                e.Via = "правила";
                // a command that looks at the bag: the bot asked for the whole bag first (its copy misses changes here)
                if (acts == null || acts.Any(a => a.Do is "scroll" or "new_range" or "add_items" or "start" or "cryst_now"))
                    c = await FreshBag(c, fg);
                if (acts != null && acts.Count == 1 && (acts[0].Do == "yes" || acts[0].Do == "no"))
                {
                    var ask = _ask;
                    _ask = null;
                    if (ask == null || ask.Value.Until < DateTime.Now || ask.Value.Tag != c.Tag)
                    {
                        e.Result = "нечего подтверждать";
                        Finish(e, false, fg, all);
                        return e;
                    }
                    if (acts[0].Do == "no")
                    {
                        e.Result = "отменено";
                        Finish(e, true, fg, all);
                        return e;
                    }
                    var rc = VExec.Apply(c, ask.Value.Acts, true);
                    e.Acts = string.Join("; ", ask.Value.Acts) + " (да)";
                    return Done(c, e, rc, "", fg, all);
                }
                if (acts == null)
                {
                    if (!UseLlm || _eng.LlmState != "ready")
                    {
                        e.Via = "—";
                        e.Result = !UseLlm ? "не понял (нейросеть выключена)"
                            : _eng.LlmState == "loading" ? "нейросеть ещё загружается"
                            : _eng.LlmState == "off" ? "не понял: нейросеть не запущена (включи «Голосовое управление»)"
                            : "нейросеть не работает: " + _eng.Error;
                        Finish(e, false, fg, all);
                        return e;
                    }
                    e.Via = "нейросеть";
                    Hud("«" + text + "» … думаю", HudKind.Busy, 10000, fg);
                    var sw = Stopwatch.StartNew();
                    try
                    {
                        var user = "Состояние:\n" + LlmPrompt.State(c, text) + "\nКоманда: «" + text + "»";
                        var json = await _eng.ChatAsync(LlmPrompt.System, user, LlmPrompt.Schema, 300, CancellationToken.None);
                        acts = LlmPrompt.ParseAnswer(json, out say);
                        LlmPrompt.NumberFix(text, acts);
                        LlmPrompt.ExplicitOnly(text, acts);   // start / stop only when said so
                    }
                    catch (Exception ex)
                    {
                        e.LlmMs = sw.ElapsedMilliseconds;
                        e.Result = "нейросеть: " + ex.Message;
                        Finish(e, false, fg, all);
                        return e;
                    }
                    e.LlmMs = sw.ElapsedMilliseconds;
                    if (acts.Count == 0)
                    {
                        e.Result = say.Length > 0 ? say : "не понял";
                        Finish(e, false, fg, all);
                        return e;
                    }
                }
                e.Acts = string.Join("; ", acts);
                var r = VExec.Apply(c, acts, false);
                return Done(c, e, r, say, fg, all);
            }
            finally { _busy.Release(); }
        }

        const int BagFreshS = 10, BagWaitMs = 2500;

        /// <summary>The bag older than BagFreshS: the bot asked for the whole bag (&lt;char&gt;.ench.req, as the page's «обновить»)
        /// and its answer awaited up to BagWaitMs; the character read again. Not while it enchants (it keeps the bag then).</summary>
        async Task<CharCtx> FreshBag(CharCtx c, long fg)
        {
            if (!c.Live || c.Running) return c;
            if (c.BagAgo >= 0 && c.BagAgo <= BagFreshS) return c;
            var asked = DateTime.Now;
            try { EnchServer.WriteSwap(Path.Combine(Paths.EnchDir, c.Tag + ".ench.req"), Encoding.ASCII.GetBytes(DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + "\r\n")); }
            catch (Exception) { return c; }
            Hud("обновляю сумку…", HudKind.Busy, BagWaitMs + 500, fg);
            var sw = Stopwatch.StartNew();
            while (sw.ElapsedMilliseconds < BagWaitMs)
            {
                await Task.Delay(120);
                c.ReadState();
                if (c.Written >= asked.AddSeconds(-1) && c.BagAgo >= 0 && c.BagAgo <= (DateTime.Now - asked).TotalSeconds + 1) break;
            }
            return c;
        }

        LogEntry Done(CharCtx c, LogEntry e, VExec.Result r, string say, long fg, Stopwatch all)
        {
            if (c.Doc.Changed)
            {
                try { EnchServer.WriteSwap(c.EnchPath, c.Doc.Bytes()); }
                catch (Exception ex) { r.Errors.Add("не записал настройки: " + ex.Message); }
            }
            if (r.Ask.Length > 0)
            {
                _ask = (c.Tag, new List<VAct>(r.Pending), DateTime.Now.AddSeconds(12));
                r.Done.Add(r.Ask);
            }
            bool show = e.Acts.Contains("ui ") || e.Acts.StartsWith("ui") || e.Acts.Contains("char");
            if (r.UiTab.Length > 0 || r.UiChar.Length > 0 || c.Doc.Changed)
                PushUi(r.UiTab, r.UiChar.Length > 0 ? r.UiChar : c.Tag, show);
            var parts = new List<string>(r.Done);
            parts.AddRange(r.Errors.Select(x => "✗ " + x));
            e.Result = string.Join(", ", parts);
            Finish(e, r.Ok, fg, all);
            return e;
        }

        void Finish(LogEntry e, bool ok, long fg, Stopwatch all)
        {
            e.Ok = ok;
            e.AllMs = all.ElapsedMilliseconds;
            AddLog(e);
            var head = e.Text.Length > 0 ? "«" + e.Text + "»  " : "";
            Hud(head + (ok ? "✓ " : "✗ ") + e.Result, ok ? HudKind.Ok : HudKind.Fail, ok ? 3200 : 4500, fg);
            if (Sounds) { if (ok) Beeps.Ok(); else Beeps.Fail(); }
        }

        /// <summary>The page shows this tab / this character at its next look; Show: the panel window up too.</summary>
        void PushUi(string tab, string ch, bool show)
        {
            lock (_lock)
            {
                _uiSeq++;
                _uiTab = tab == "panel" ? "" : tab;
                _uiChar = ch;
            }
            if (show && ShowPanel != null) _ui.BeginInvoke(ShowPanel);
        }

        void AddLog(LogEntry e)
        {
            lock (_lock)
            {
                e.N = ++_seq;
                e.T = DateTime.Now.ToString("HH:mm:ss", CultureInfo.InvariantCulture);
                _log.Add(e);
                while (_log.Count > 40) _log.RemoveAt(0);
            }
            try
            {
                File.AppendAllText(Path.Combine(Paths.LogsDir, "voice.log"),
                    e.T + " [" + e.Char + "] «" + e.Text + "» via " + e.Via + " -> " + e.Acts + " => " + (e.Ok ? "OK " : "FAIL ") + e.Result +
                    " (stt " + e.SttMs + " ms, llm " + e.LlmMs + " ms, all " + e.AllMs + " ms)\r\n");
            }
            catch (Exception) { }
        }

        // ---------- the page ----------

        public string StateJson()
        {
            var sb = new StringBuilder("{");
            sb.Append("\"on\":").Append(On ? "true" : "false");
            sb.Append(",\"key\":").Append(JsonSerializer.Serialize(Key));
            sb.Append(",\"mic\":").Append(MicIndex);
            sb.Append(",\"llm\":").Append(UseLlm ? "true" : "false");
            sb.Append(",\"beeps\":").Append(Sounds ? "true" : "false");
            sb.Append(",\"mics\":").Append(JsonSerializer.Serialize(MicRecorder.Devices()));
            sb.Append(",\"stt\":").Append(JsonSerializer.Serialize(_eng.SttState));
            sb.Append(",\"llmState\":").Append(JsonSerializer.Serialize(_eng.LlmState));
            sb.Append(",\"err\":").Append(JsonSerializer.Serialize(_eng.Error.Length > 0 ? _eng.Error : _mic.Error));
            sb.Append(",\"missing\":").Append(JsonSerializer.Serialize(VoiceEngines.Missing() ?? ""));
            sb.Append(",\"level\":").Append(_mic.IsOpen ? _mic.Level.ToString("0.###", CultureInfo.InvariantCulture) : "-1");
            lock (_lock) sb.Append(",\"ui\":{\"seq\":").Append(_uiSeq).Append(",\"tab\":").Append(JsonSerializer.Serialize(_uiTab))
                             .Append(",\"char\":").Append(JsonSerializer.Serialize(_uiChar)).Append('}');
            sb.Append(",\"log\":[");
            lock (_lock)
            {
                for (int i = _log.Count - 1; i >= 0; i--)
                {
                    var e = _log[i];
                    if (i < _log.Count - 1) sb.Append(',');
                    sb.Append("{\"n\":").Append(e.N).Append(",\"t\":").Append(JsonSerializer.Serialize(e.T))
                      .Append(",\"char\":").Append(JsonSerializer.Serialize(e.Char)).Append(",\"text\":").Append(JsonSerializer.Serialize(e.Text))
                      .Append(",\"via\":").Append(JsonSerializer.Serialize(e.Via)).Append(",\"acts\":").Append(JsonSerializer.Serialize(e.Acts))
                      .Append(",\"result\":").Append(JsonSerializer.Serialize(e.Result)).Append(",\"ok\":").Append(e.Ok ? "true" : "false")
                      .Append(",\"stt\":").Append(e.SttMs).Append(",\"llm\":").Append(e.LlmMs).Append(",\"all\":").Append(e.AllMs).Append('}');
                }
            }
            return sb.Append("]}").ToString();
        }

        /// <summary>A .wav sent by the page / a test: the same path as a spoken take.</summary>
        public async Task<LogEntry?> HandleWav(byte[] wav)
        {
            if (_eng.SttState != "ready") return null;
            var sw = Stopwatch.StartNew();
            var text = CleanStt(await _eng.TranscribeAsync(wav, SttPrompt, CancellationToken.None));
            var stt = sw.ElapsedMilliseconds;
            if (text.Length == 0) return new LogEntry { Result = "тишина", SttMs = stt };
            return await HandleText(text, 0, stt, sw);
        }

        // ---------- the key names (the page's) ----------

        public static int KeyVk(string name)
        {
            if (string.IsNullOrEmpty(name)) return 0;
            var n = name.Trim();
            if (n.Length == 1)
            {
                char ch = char.ToUpperInvariant(n[0]);
                if ((ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) return ch;
            }
            if (n.Length >= 2 && (n[0] == 'F' || n[0] == 'f') && int.TryParse(n.Substring(1), out var f) && f >= 1 && f <= 24) return 0x6F + f;
            if (n.StartsWith("Num", StringComparison.OrdinalIgnoreCase) && n.Length == 4 && char.IsDigit(n[3])) return 0x60 + (n[3] - '0');
            return n switch
            {
                "RControl" => 0xA3, "LControl" => 0xA2, "RAlt" => 0xA5, "LAlt" => 0xA4, "RShift" => 0xA1, "LShift" => 0xA0,
                "CapsLock" => 0x14, "Space" => 0x20, "Tab" => 0x09, "Pause" => 0x13, "ScrollLock" => 0x91, "Insert" => 0x2D,
                "Home" => 0x24, "End" => 0x23, "PageUp" => 0x21, "PageDown" => 0x22, "Delete" => 0x2E, "Backquote" => 0xC0,
                "Mouse3" => 0x04, "Mouse4" => 0x05, "Mouse5" => 0x06, "NumAdd" => 0x6B, "NumSub" => 0x6D, "NumMul" => 0x6A, "NumDiv" => 0x6F,
                _ => 0,
            };
        }

        // ---------- the line over the game ----------

        public enum HudKind { Rec, Busy, Ok, Fail }

        void Hud(string text, HudKind kind, int ms, long fg)
        {
            _ui.BeginInvoke(new Action(() =>
            {
                _hud ??= new VoiceHud();
                _hud.Say(text, kind, ms, new IntPtr(fg));
            }));
        }
    }

    /// <summary>A small topmost line at the top of the game window: what is heard / done. Clicks go through it.</summary>
    sealed class VoiceHud : Window
    {
        readonly System.Windows.Controls.Border _box;
        readonly System.Windows.Controls.TextBlock _txt;
        readonly DispatcherTimer _hide = new DispatcherTimer();

        [StructLayout(LayoutKind.Sequential)] struct RECT { public int L, T, R, B; }
        [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr h, out RECT r);
        [DllImport("user32.dll")] static extern int GetWindowLong(IntPtr h, int i);
        [DllImport("user32.dll")] static extern int SetWindowLong(IntPtr h, int i, int v);

        public VoiceHud()
        {
            WindowStyle = WindowStyle.None;
            AllowsTransparency = true;
            Background = Brushes.Transparent;
            Topmost = true;
            ShowInTaskbar = false;
            ShowActivated = false;
            Focusable = false;
            SizeToContent = SizeToContent.WidthAndHeight;
            _txt = new System.Windows.Controls.TextBlock
            {
                Foreground = Brushes.White, FontSize = 15, FontFamily = new FontFamily("Segoe UI"), MaxWidth = 760,
                TextWrapping = TextWrapping.Wrap,
            };
            _box = new System.Windows.Controls.Border
            {
                CornerRadius = new CornerRadius(10), Padding = new Thickness(14, 8, 14, 9), Child = _txt,
                BorderThickness = new Thickness(1),
            };
            Content = _box;
            _hide.Tick += (s, e) => { _hide.Stop(); Hide(); };
            SourceInitialized += (s, e) =>
            {
                var h = new WindowInteropHelper(this).Handle;
                SetWindowLong(h, -20, GetWindowLong(h, -20) | 0x20 | 0x80 | 0x08000000);   // transparent, toolwindow, noactivate
            };
        }

        public void Say(string text, VoiceHub.HudKind kind, int ms, IntPtr anchor)
        {
            _txt.Text = text;
            var (bg, line) = kind switch
            {
                VoiceHub.HudKind.Rec => (Color.FromArgb(235, 120, 24, 36), Color.FromRgb(255, 92, 110)),
                VoiceHub.HudKind.Busy => (Color.FromArgb(235, 28, 32, 48), Color.FromRgb(140, 150, 190)),
                VoiceHub.HudKind.Ok => (Color.FromArgb(235, 16, 52, 38), Color.FromRgb(70, 210, 140)),
                _ => (Color.FromArgb(235, 60, 22, 22), Color.FromRgb(240, 110, 90)),
            };
            _box.Background = new SolidColorBrush(bg);
            _box.BorderBrush = new SolidColorBrush(line);
            if (!IsVisible) Show();
            UpdateLayout();
            double x, y;
            var src = PresentationSource.FromVisual(this);
            double sx = src?.CompositionTarget?.TransformFromDevice.M11 ?? 1, sy = src?.CompositionTarget?.TransformFromDevice.M22 ?? 1;
            if (anchor != IntPtr.Zero && GetWindowRect(anchor, out var r) && r.R - r.L > 200)
            {
                x = (r.L + r.R) / 2.0 * sx - ActualWidth / 2;
                y = r.T * sy + 70;
            }
            else
            {
                var wa = SystemParameters.WorkArea;
                x = wa.Left + (wa.Width - ActualWidth) / 2;
                y = wa.Top + 70;
            }
            Left = x;
            Top = y;
            _hide.Stop();
            _hide.Interval = TimeSpan.FromMilliseconds(ms);
            _hide.Start();
        }
    }
}
