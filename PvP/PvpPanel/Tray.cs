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

namespace PvpPanel
{
    /// <summary>The tray icon over the panel's own PvP server (PvpServer): its state in the icon colour (grey not running /
    /// amber no bots / green bots in), its menu (the bots in, the profiles, the panel, the server), balloons on bots
    /// in / out. The tray itself is no page: the bots do not build their state for it.</summary>
    sealed class Tray : IDisposable
    {
        static readonly Color Bg = Color.FromArgb(9, 12, 17);
        static readonly Color Off = Color.FromArgb(125, 133, 148);
        static readonly Color Idle = Color.FromArgb(255, 191, 90);
        static readonly Color On = Color.FromArgb(94, 214, 140);

        readonly PvpServer _server = new PvpServer();
        readonly ServerClient _client = new ServerClient();      // only for an old pvp_server.py holding the ports
        readonly Dispatcher _ui = Dispatcher.CurrentDispatcher;
        readonly WinForms.NotifyIcon _icon;
        readonly WinForms.ContextMenuStrip _menu;
        readonly DispatcherTimer _timer;
        readonly Icon _icoOff, _icoIdle, _icoOn;
        ServerStatus _st = new ServerStatus();
        HashSet<string>? _online;      // null: not running yet (no balloons for the bots already in)
        bool _busy, _refreshQueued;
        MainWindow? _win;

        public static ImageSource WindowIcon { get; } = MakeImage(On);

        public Tray()
        {
            _icoOff = MakeIcon(Off);
            _icoIdle = MakeIcon(Idle);
            _icoOn = MakeIcon(On);
            _menu = new WinForms.ContextMenuStrip();
            _menu.Opening += (s, e) =>
            {
                BuildMenu();
                e.Cancel = false;        // (an empty strip comes cancelled)
            };
            _icon = new WinForms.NotifyIcon
            {
                Icon = _icoOff,
                Text = "PvP Panel",
                ContextMenuStrip = _menu,
                Visible = true,
            };
            _icon.MouseClick += (s, e) =>
            {
                if (e.Button == WinForms.MouseButtons.Left) ShowPanel();
            };
            // the server says what changed (off the UI thread): one refresh queued at a time
            _server.Changed += () =>
            {
                if (_refreshQueued) return;
                _refreshQueued = true;
                _ui.BeginInvoke(new Action(() =>
                {
                    _refreshQueued = false;
                    Refresh();
                }));
            };
            _timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(2) };   // pvp.ini edited by hand etc.
            _timer.Tick += (s, e) => Refresh();
            _timer.Start();
            _ = StartServerAsync(false);
        }

        // ---------- status ----------

        void Refresh() => Apply(_server.Snapshot());

        void Apply(ServerStatus st)
        {
            _st = st;
            if (st.Up)
            {
                var now = new HashSet<string>(st.Online, StringComparer.OrdinalIgnoreCase);
                if (_online != null && PanelSettings.NotifyBots)
                {
                    var inn = now.Where(n => !_online.Contains(n)).ToList();
                    var gone = _online.Where(n => !now.Contains(n)).ToList();
                    var parts = new List<string>();
                    if (inn.Count > 0) parts.Add("Online: " + string.Join(", ", inn));
                    if (gone.Count > 0) parts.Add("Left: " + string.Join(", ", gone));
                    if (parts.Count > 0) _icon.ShowBalloonTip(3000, "PvP", string.Join("\n", parts), WinForms.ToolTipIcon.None);
                }
                _online = now;
            }
            else
                _online = null;
            _icon.Icon = !st.Up ? _icoOff : st.Online.Count > 0 ? _icoOn : _icoIdle;
            _icon.Text = Tip(st);
            _win?.OnStatus(st);
        }

        static string Tip(ServerStatus st)
        {
            string s;
            if (!st.Up) s = "PvP: server not running";
            else
            {
                var bots = st.Online.Count == 0 ? "no bots" : st.Online.Count + (st.Online.Count == 1 ? " bot" : " bots");
                s = "PvP: " + bots + ", profile " + ProfileName(st.Active);
            }
            return s.Length > 63 ? s.Substring(0, 62) + "…" : s;
        }

        static string ProfileName(string id)
        {
            var p = ProfileFiles.List().FirstOrDefault(x => string.Equals(x.Id, id, StringComparison.OrdinalIgnoreCase));
            return p?.Name ?? id;
        }

        // ---------- the menu ----------

        void BuildMenu()
        {
            Refresh();
            var st = _st;
            _menu.Items.Clear();
            if (st.Up)
            {
                _menu.Items.Add(Disabled("Server running (" + PvpServer.HttpPort + " / " + PvpServer.BotPort + ")"));
                if (st.Online.Count == 0) _menu.Items.Add(Disabled("No bots online"));
                foreach (var n in st.Online) _menu.Items.Add(Disabled("● " + n));
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

            var prof = new WinForms.ToolStripMenuItem("Profile");
            var active = st.Active.Length > 0 ? st.Active : ProfileFiles.Active();
            var list = ProfileFiles.List();
            if (list.Count == 0) prof.DropDownItems.Add(Disabled("no profiles"));
            foreach (var p in list)
            {
                var id = p.Id;
                var text = p.Name == p.Id ? p.Name : p.Name + "   (" + p.Id + ")";
                prof.DropDownItems.Add(new WinForms.ToolStripMenuItem(text, null, async (s, e) => await SetActiveAsync(id))
                {
                    Checked = string.Equals(id, active, StringComparison.OrdinalIgnoreCase),
                });
            }
            _menu.Items.Add(prof);
            _menu.Items.Add(new WinForms.ToolStripMenuItem("Reset stats", null, async (s, e) => await StatResetAsync())
            {
                Enabled = st.Up && st.Online.Count > 0,
            });
            _menu.Items.Add(new WinForms.ToolStripSeparator());

            if (st.Up)
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Restart server", null, async (s, e) => await RestartAsync())
                {
                    Enabled = !_busy,
                });
            else
                _menu.Items.Add(new WinForms.ToolStripMenuItem("Start server", null, async (s, e) => await StartServerAsync(true))
                {
                    Enabled = !_busy,
                });

            var opt = new WinForms.ToolStripMenuItem("Settings");
            opt.DropDownItems.Add(Check("Notify when bots come and go", PanelSettings.NotifyBots, v => PanelSettings.NotifyBots = v));
            opt.DropDownItems.Add(Check("Start with Windows", PanelSettings.AutoStart, v => PanelSettings.AutoStart = v));
            opt.DropDownItems.Add(new WinForms.ToolStripSeparator());
            opt.DropDownItems.Add(new WinForms.ToolStripMenuItem("Open PvP folder", null, (s, e) => OpenExternal(Paths.PvpDir)));
            opt.DropDownItems.Add(new WinForms.ToolStripMenuItem("Server log", null, (s, e) => OpenExternal(Paths.ServerLog)));
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

        async Task SetActiveAsync(string id)
        {
            // pvp.ini written either way (the script reads it itself); running -> the bots are told at once
            try { await _server.SetActiveAsync(id); }
            catch (Exception ex) { Balloon("Profile not switched: " + ex.Message, true); }
            Refresh();
        }

        async Task StatResetAsync()
        {
            await _server.StatResetAsync();
            Balloon("Stats reset on every bot", false);
        }

        /// <summary>The server of the panel started. The ports taken by the old pvp_server.py: it is stopped (its quit
        /// command / its pid / its command line) and the panel takes them.</summary>
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
                var other = await _client.GetStatusAsync();
                if (other.Up && other.Pid != Environment.ProcessId)
                {
                    if (await ServerProcess.StopAsync(_client, other) && _server.Start())
                    {
                        Balloon("The old server (pvp_server.py) was stopped - the panel runs the server now", false);
                        return;
                    }
                }
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
            _icon.ShowBalloonTip(3000, "PvP Panel", text, error ? WinForms.ToolTipIcon.Warning : WinForms.ToolTipIcon.Info);

        public static void OpenExternal(string target)
        {
            try { Process.Start(new ProcessStartInfo(target) { UseShellExecute = true })?.Dispose(); }
            catch (Exception) { }
        }

        async void Exit()
        {
            _timer.Stop();
            if (_win != null) await _win.ExitCloseAsync();   // a profile edit still waiting is saved first
            _server.Stop();
            Dispose();
            System.Windows.Application.Current.Shutdown();
        }

        public void Dispose()
        {
            _timer.Stop();
            _server.Stop();
            _icon.Visible = false;
            _icon.Dispose();
            _menu.Dispose();
        }

        // ---------- the icon: a dark disc, a ring and crossed swords in the state colour ----------

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
            using var sw = new Pen(c, 3.2f) { StartCap = LineCap.Round, EndCap = LineCap.Round };
            g.DrawLine(sw, 10, 10, 22, 22);
            g.DrawLine(sw, 22, 10, 10, 22);
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
