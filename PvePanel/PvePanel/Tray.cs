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

namespace PvePanel
{
    /// <summary>The tray icon over the panel's own server (PveServer): its state in the icon colour (grey not running /
    /// amber no bot / green a bot on, paused / blue farming), its menu (the characters, the panel, the folders), a balloon
    /// on a bot's alert (death, champion, a player, PvP) and when a farm pauses by itself.</summary>
    sealed class Tray : IDisposable
    {
        static readonly Color Bg = Color.FromArgb(10, 13, 18);
        static readonly Color Off = Color.FromArgb(125, 133, 148);
        static readonly Color Idle = Color.FromArgb(255, 191, 90);
        static readonly Color On = Color.FromArgb(77, 212, 172);
        static readonly Color Run = Color.FromArgb(90, 169, 255);

        readonly PveServer _server = new PveServer();
        readonly WinForms.NotifyIcon _icon;
        readonly WinForms.ContextMenuStrip _menu;
        readonly DispatcherTimer _timer;
        readonly Icon _icoOff, _icoIdle, _icoOn, _icoRun;
        PveStatus _st = new PveStatus();
        Dictionary<string, CharStatus>? _was;   // tag -> its status the last time (null: not looked yet)
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
                e.Cancel = false;
            };
            _icon = new WinForms.NotifyIcon
            {
                Icon = _icoOff,
                Text = "PvE Panel",
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
            var ui = Dispatcher.CurrentDispatcher;
            PveServer.Quit = () => ui.BeginInvoke(new Action(Exit));
        }

        // ---------- status ----------

        void Refresh() => Apply(_server.Snapshot());

        void Apply(PveStatus st)
        {
            _st = st;
            var now = st.Chars.ToDictionary(c => c.Tag, c => c, StringComparer.OrdinalIgnoreCase);
            if (_was != null && PanelSettings.NotifyAlerts)
                foreach (var c in st.Chars)
                {
                    if (!_was.TryGetValue(c.Tag, out var w)) continue;
                    if (c.AlertSeq > w.AlertSeq && c.Alert.Length > 0)
                        _icon.ShowBalloonTip(5000, "PvE: " + c.Name, c.Alert, WinForms.ToolTipIcon.Warning);
                    else if (w.Running && !c.Running && c.Online)
                        _icon.ShowBalloonTip(4000, "PvE: " + c.Name, "Paused - " + c.What, WinForms.ToolTipIcon.Info);
                }
            _was = now;
            var farming = st.Chars.Any(c => c.Online && c.Running);
            _icon.Icon = !st.Up ? _icoOff : farming ? _icoRun : st.Chars.Any(c => c.Online) ? _icoOn : _icoIdle;
            _icon.Text = Tip(st);
            _win?.OnStatus(st);
        }

        static string Tip(PveStatus st)
        {
            string s;
            if (!st.Up) s = "PvE: server not running";
            else
            {
                var on = st.Chars.Where(c => c.Online).ToList();
                var run = on.Where(c => c.Running).Select(c => c.Name).ToList();
                s = run.Count > 0 ? "Farming: " + string.Join(", ", run)
                  : on.Count == 0 ? "PvE: no bot" : "PvE (paused): " + string.Join(", ", on.Select(c => c.Name));
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
                if (on.Count == 0) _menu.Items.Add(Disabled("No bot runs pve.txt"));
                foreach (var c in on)
                    _menu.Items.Add(Disabled("● " + c.Name + (c.Running ? "  - farming, " + c.Kills + " kills" : "  - paused")));
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
            _menu.Items.Add(new WinForms.ToolStripMenuItem("Open in browser", null, (s, e) => OpenExternal(Paths.PageUrl)) { Enabled = st.Up });
            _menu.Items.Add(new WinForms.ToolStripSeparator());
            if (st.Up)
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Restart server", null, async (s, e) => await RestartAsync()) { Enabled = !_busy });
            else
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Start server", null, async (s, e) => await StartServerAsync(true)) { Enabled = !_busy });

            var opt = new WinForms.ToolStripMenuItem("Settings");
            opt.DropDownItems.Add(Check("Notify on alerts and pauses", PanelSettings.NotifyAlerts, v => PanelSettings.NotifyAlerts = v));
            opt.DropDownItems.Add(Check("Start with Windows", PanelSettings.AutoStart, v => PanelSettings.AutoStart = v));
            opt.DropDownItems.Add(new WinForms.ToolStripSeparator());
            opt.DropDownItems.Add(new WinForms.ToolStripMenuItem("Open PvePanel folder", null, (s, e) => OpenExternal(Paths.PveDir)));
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
            _icon.ShowBalloonTip(3000, "PvE Panel", text, error ? WinForms.ToolTipIcon.Warning : WinForms.ToolTipIcon.Info);

        public static void OpenExternal(string target)
        {
            try { Process.Start(new ProcessStartInfo(target) { UseShellExecute = true })?.Dispose(); }
            catch (Exception) { }
        }

        async void Exit()
        {
            _timer.Stop();
            if (_win != null) await _win.ExitCloseAsync();
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

        // ---------- the icon: a dark disc, a ring and a sword in the state colour ----------

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
            // the blade (corner to corner), the guard, the grip
            g.FillPolygon(br, new[] { new PointF(23.5f, 7.5f), new PointF(24.5f, 8.5f), new PointF(13.5f, 19.5f), new PointF(12.5f, 18.5f) });
            g.FillPolygon(br, new[] { new PointF(22, 7), new PointF(25, 7), new PointF(25, 10) });
            using (var guard = new Pen(c, 2.4f)) g.DrawLine(guard, 10.5f, 16.5f, 15.5f, 21.5f);
            using (var grip = new Pen(c, 2.6f)) g.DrawLine(grip, 12.8f, 19.2f, 8.5f, 23.5f);
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
            var h = bmp.GetHicon();
            try
            {
                var src = Imaging.CreateBitmapSourceFromHIcon(h, System.Windows.Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                src.Freeze();
                return src;
            }
            finally { DestroyIcon(h); }
        }
    }
}
