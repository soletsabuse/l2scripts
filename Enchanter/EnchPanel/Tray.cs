using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;
using Color = System.Drawing.Color;
using Pen = System.Drawing.Pen;
using WinForms = System.Windows.Forms;

namespace EnchPanel
{
    /// <summary>The tray icon over the panel's own server (EnchServer): its state in the icon colour (grey not running /
    /// amber no bot / green a bot on / blue enchanting), its menu (the characters, the panel, the folders), a balloon
    /// when a run is over.</summary>
    sealed class Tray : IDisposable
    {
        static readonly Color Bg = Color.FromArgb(9, 12, 17);
        static readonly Color Off = Color.FromArgb(125, 133, 148);
        static readonly Color Idle = Color.FromArgb(255, 191, 90);
        static readonly Color On = Color.FromArgb(94, 214, 140);
        static readonly Color Run = Color.FromArgb(110, 170, 255);

        readonly EnchServer _server = new EnchServer();
        readonly WinForms.NotifyIcon _icon;
        readonly WinForms.ContextMenuStrip _menu;
        readonly DispatcherTimer _timer;
        readonly Icon _icoOff, _icoIdle, _icoOn, _icoRun;
        EnchStatus _st = new EnchStatus();
        Dictionary<string, string>? _runs;     // char -> its run state the last time (null: not looked yet)
        bool _busy;
        MainWindow? _win;

        public static ImageSource WindowIcon { get; } = MakeImage(Run);

        public Tray()
        {
            _icoOff = MakeIcon(Off);
            _icoIdle = MakeIcon(Idle);
            _icoOn = MakeIcon(On);
            _icoRun = MakeIcon(Run);
            _menu = new WinForms.ContextMenuStrip();
            _menu.Opening += (s, e) =>
            {
                BuildMenu();
                e.Cancel = false;        // (an empty strip comes cancelled)
            };
            _icon = new WinForms.NotifyIcon
            {
                Icon = _icoOff,
                Text = "Enchanter",
                ContextMenuStrip = _menu,
                Visible = true,
            };
            _icon.MouseClick += (s, e) =>
            {
                if (e.Button == WinForms.MouseButtons.Left) ShowPanel();
            };
            _timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(2) };
            _timer.Tick += (s, e) => Refresh();
            _timer.Start();
            _ = StartServerAsync(false);
        }

        // ---------- status ----------

        void Refresh() => Apply(_server.Snapshot());

        void Apply(EnchStatus st)
        {
            _st = st;
            var now = st.Chars.ToDictionary(c => c.Name, c => c.State, StringComparer.OrdinalIgnoreCase);
            if (_runs != null && PanelSettings.NotifyRuns)
                foreach (var c in st.Chars)
                    if (_runs.TryGetValue(c.Name, out var was) && was == "running" && c.State != "running" && c.State.Length > 0)
                        _icon.ShowBalloonTip(4000, "Enchanter: " + c.Name, EndText(c), c.State == "done" ? WinForms.ToolTipIcon.Info : WinForms.ToolTipIcon.Warning);
            _runs = now;
            var running = st.Chars.Any(c => c.Online && c.State == "running");
            _icon.Icon = !st.Up ? _icoOff : running ? _icoRun : st.Chars.Any(c => c.Online) ? _icoOn : _icoIdle;
            _icon.Text = Tip(st);
            _win?.OnStatus(st);
        }

        static string EndText(CharStatus c)
        {
            var what = c.End switch
            {
                "done" => "done, every item is at its target",
                "count" => "done: " + c.Done + " items at their target",
                "noscroll" => "out of scrolls",
                "nostone" => "out of stones",
                "stonepkt" => "stones are not ready yet (the stone packet is not sniffed)",
                "limit" => "the scroll limit",
                "broke" => "an item broke",
                "skipped" => "only skipped items left",
                "empty" => "no items picked",
                "page" => "stopped",
                "none" => "the server does not enchant",
                "offline" => "not in the game",
                "dead" => "dead",
                "crystal" => "crystallized",
                "usefail" => "the scroll does not open the window",
                _ => c.State,
            };
            return what + " - " + c.Tries + " tries, " + c.Ok + " ok, " + c.Broke + " broke";
        }

        static string Tip(EnchStatus st)
        {
            string s;
            if (!st.Up) s = "Enchanter: server not running";
            else
            {
                var on = st.Chars.Where(c => c.Online).ToList();
                var run = on.Where(c => c.State == "running").Select(c => c.Name).ToList();
                s = run.Count > 0 ? "Enchanting: " + string.Join(", ", run)
                  : on.Count == 0 ? "Enchanter: no bot" : "Enchanter: " + string.Join(", ", on.Select(c => c.Name));
            }
            return s.Length > 63 ? s.Substring(0, 62) + "…" : s;
        }

        // ---------- the menu ----------

        void BuildMenu()
        {
            Refresh();
            var st = _st;
            _menu.Items.Clear();
            if (st.Up)
            {
                _menu.Items.Add(Disabled("Server running (" + Paths.HttpPort + ")"));
                var on = st.Chars.Where(c => c.Online).ToList();
                if (on.Count == 0) _menu.Items.Add(Disabled("No bot runs enchant.txt"));
                foreach (var c in on)
                    _menu.Items.Add(Disabled("● " + c.Name + (c.State == "running" ? "  - enchanting, " + c.Tries + " tries" +
                        (c.DoneMax > 0 ? ", " + c.Done + "/" + c.DoneMax + " done" : "") : "")));
            }
            else
            {
                _menu.Items.Add(Disabled("Server not running"));
                if (_server.LastError.Length > 0) _menu.Items.Add(Disabled(_server.LastError));
            }
            _menu.Items.Add(new WinForms.ToolStripSeparator());

            var open = new WinForms.ToolStripMenuItem("Open panel", null, (s, e) => ShowPanel());
            open.Font = new Font(open.Font, System.Drawing.FontStyle.Bold);
            _menu.Items.Add(open);
            _menu.Items.Add(new WinForms.ToolStripMenuItem("Open in browser", null, (s, e) => OpenExternal(Paths.PageUrl))
            {
                Enabled = st.Up,
            });
            _menu.Items.Add(new WinForms.ToolStripSeparator());
            if (st.Up)
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Restart server", null, async (s, e) => await RestartAsync()) { Enabled = !_busy });
            else
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Start server", null, async (s, e) => await StartServerAsync(true)) { Enabled = !_busy });

            var opt = new WinForms.ToolStripMenuItem("Settings");
            opt.DropDownItems.Add(Check("Notify when a run is over", PanelSettings.NotifyRuns, v => PanelSettings.NotifyRuns = v));
            opt.DropDownItems.Add(Check("Start with Windows", PanelSettings.AutoStart, v => PanelSettings.AutoStart = v));
            opt.DropDownItems.Add(new WinForms.ToolStripSeparator());
            opt.DropDownItems.Add(new WinForms.ToolStripMenuItem("Open Enchanter folder", null, (s, e) => OpenExternal(Paths.EnchDir)));
            opt.DropDownItems.Add(new WinForms.ToolStripMenuItem("Open Logs folder", null, (s, e) => OpenExternal(Paths.LogsDir)));
            _menu.Items.Add(opt);
            _menu.Items.Add(new WinForms.ToolStripSeparator());
            _menu.Items.Add(new WinForms.ToolStripMenuItem("Exit", null, (s, e) => Exit()));
        }

        static WinForms.ToolStripMenuItem Disabled(string text) => new WinForms.ToolStripMenuItem(text) { Enabled = false };

        WinForms.ToolStripMenuItem Check(string text, bool value, Action<bool> set)
        {
            var it = new WinForms.ToolStripMenuItem(text) { CheckOnClick = true, Checked = value };
            it.CheckedChanged += (s, e) =>
            {
                try { set(it.Checked); }
                catch (Exception ex) { Balloon("Failed: " + ex.Message, true); }
            };
            return it;
        }

        // ---------- actions ----------

        public void ShowPanel()
        {
            _win ??= new MainWindow(() => StartServerAsync(true));
            _win.ShowPanel(_server.Snapshot());
        }

        public async Task StartServerAsync(bool say)
        {
            if (_busy) return;
            _busy = true;
            try
            {
                if (_server.Start())
                {
                    if (say) Balloon("Server started", false);
                    return;
                }
                await Task.Delay(1);
                Balloon("Server not started: " + _server.LastError, true);
            }
            finally
            {
                _busy = false;
                Refresh();
            }
        }

        async Task RestartAsync()
        {
            _server.Stop();
            await Task.Delay(300);
            await StartServerAsync(true);
        }

        void Balloon(string text, bool error) =>
            _icon.ShowBalloonTip(3000, "Enchanter", text, error ? WinForms.ToolTipIcon.Warning : WinForms.ToolTipIcon.Info);

        public static void OpenExternal(string target)
        {
            try { Process.Start(new ProcessStartInfo(target) { UseShellExecute = true })?.Dispose(); }
            catch (Exception) { }
        }

        async void Exit()
        {
            _timer.Stop();
            if (_win != null) await _win.ExitCloseAsync();   // a settings edit still waiting is saved first
            _server.Stop();
            Dispose();
            System.Windows.Application.Current.Shutdown();
        }

        bool _disposed;

        public void Dispose()
        {
            if (_disposed) return;
            _disposed = true;
            _timer.Stop();
            _server.Stop();
            _icon.Visible = false;
            _icon.Dispose();
            _menu.Dispose();
        }

        // ---------- the icon: a dark disc, a ring and a four-point spark in the state colour ----------

        [DllImport("user32.dll")]
        static extern bool DestroyIcon(IntPtr hIcon);

        static Bitmap Draw(Color c)
        {
            var bmp = new Bitmap(32, 32);
            using var g = Graphics.FromImage(bmp);
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.Clear(Color.Transparent);
            using (var bg = new SolidBrush(Bg)) g.FillEllipse(bg, 1, 1, 30, 30);
            using (var ring = new Pen(c, 2.5f)) g.DrawEllipse(ring, 2.5f, 2.5f, 27, 27);
            using var br = new SolidBrush(c);
            g.FillPolygon(br, new[]
            {
                new PointF(16, 6.5f), new PointF(18.6f, 13.4f), new PointF(25.5f, 16), new PointF(18.6f, 18.6f),
                new PointF(16, 25.5f), new PointF(13.4f, 18.6f), new PointF(6.5f, 16), new PointF(13.4f, 13.4f),
            });
            return bmp;
        }

        static Icon MakeIcon(Color c)
        {
            using var bmp = Draw(c);
            var h = bmp.GetHicon();
            try
            {
                using var tmp = Icon.FromHandle(h);
                return (Icon)tmp.Clone();
            }
            finally { DestroyIcon(h); }
        }

        static ImageSource MakeImage(Color c)
        {
            using var bmp = Draw(c);
            var h = bmp.GetHicon();            // (an HBITMAP would lose the transparency)
            try
            {
                var src = Imaging.CreateBitmapSourceFromHIcon(h, System.Windows.Int32Rect.Empty,
                    BitmapSizeOptions.FromEmptyOptions());
                src.Freeze();
                return src;
            }
            finally { DestroyIcon(h); }
        }
    }
}
