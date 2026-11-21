using System;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Windows;
using Microsoft.Web.WebView2.Core;

namespace PvePanel
{
    /// <summary>The panel window: the farm's page (pve.html, served by the panel) inside WebView2. Closing hides it to the
    /// tray and unloads the page (a settings change still waiting is saved first).</summary>
    public partial class MainWindow : Window
    {
        readonly Func<Task> _startServer;
        bool _up, _exiting, _webFailed, _reload = true;
        string _error = "";

        public MainWindow(Func<Task> startServer)
        {
            InitializeComponent();
            _startServer = startServer;
            Icon = Tray.WindowIcon;
            Web.DefaultBackgroundColor = System.Drawing.Color.FromArgb(10, 13, 18);
            LoadBounds();
        }

        internal async void ShowPanel(PveStatus st)
        {
            _up = st.Up;
            _error = st.Error;
            if (!IsVisible) Show();
            if (WindowState == WindowState.Minimized) WindowState = WindowState.Normal;
            Activate();
            await LoadAsync();
        }

        /// <summary>The tray's status every 2 s: the server went down -> the "not running" pane; back up -> the page again.</summary>
        internal void OnStatus(PveStatus st)
        {
            var was = _up;
            _up = st.Up;
            _error = st.Error;
            if (!st.Up) _reload = true;
            if (!IsVisible) return;
            if (!st.Up) ShowDown(false);
            else if (!was || _reload) _ = LoadAsync();
        }

        async Task LoadAsync()
        {
            if (!_up)
            {
                ShowDown(false);
                return;
            }
            if (_webFailed) return;
            try
            {
                await EnsureWebAsync();
                Down.Visibility = Visibility.Collapsed;
                var src = Web.CoreWebView2.Source ?? "";
                if (_reload || !src.StartsWith(Paths.PageUrl, StringComparison.OrdinalIgnoreCase))
                    Web.CoreWebView2.Navigate(Paths.PageUrl);
                _reload = false;
            }
            catch (Exception ex)
            {
                _webFailed = true;
                DownTitle.Text = "The page cannot be shown inside the panel";
                DownText.Text = "WebView2: " + ex.Message + "\nOpen it in the browser - it is the same page there.";
                StartBtn.Visibility = Visibility.Collapsed;
                BrowserBtn.Visibility = Visibility.Visible;
                Down.Visibility = Visibility.Visible;
            }
        }

        async Task EnsureWebAsync()
        {
            if (Web.CoreWebView2 != null) return;
            var env = await CoreWebView2Environment.CreateAsync(null, Paths.WebData);
            await Web.EnsureCoreWebView2Async(env);
            var cw = Web.CoreWebView2!;
            cw.Settings.IsStatusBarEnabled = false;
            cw.NewWindowRequested += (s, e) =>
            {
                e.Handled = true;
                Tray.OpenExternal(e.Uri);
            };
        }

        void ShowDown(bool starting)
        {
            if (_webFailed) return;
            DownTitle.Text = starting ? "Starting the server…" : "PvE server not running";
            DownText.Text = "The server is built into the panel (port " + Paths.HttpPort + "). The page needs it: it reads and writes the " +
                            "farm's files (Library\\PvePanel) through it." +
                            (_error.Length > 0 && !starting ? "\n\nNot started: " + _error : "");
            StartBtn.IsEnabled = !starting;
            StartBtn.Visibility = Visibility.Visible;
            BrowserBtn.Visibility = Visibility.Collapsed;
            Down.Visibility = Visibility.Visible;
        }

        async void StartBtn_Click(object sender, RoutedEventArgs e)
        {
            ShowDown(true);
            await _startServer();
            if (!_up) ShowDown(false);
        }

        void BrowserBtn_Click(object sender, RoutedEventArgs e) => Tray.OpenExternal(Paths.PageUrl);

        protected override void OnClosing(CancelEventArgs e)
        {
            SaveBounds();
            if (!_exiting)
            {
                e.Cancel = true;
                Hide();
                Unload();
            }
            base.OnClosing(e);
        }

        async void Unload()
        {
            _reload = true;
            try
            {
                await FlushAsync();
                if (!IsVisible) Web.CoreWebView2?.Navigate("about:blank");
            }
            catch (Exception) { }
        }

        /// <summary>The page's pending saves done now (pve.html: flushAll), waited for up to 3 s.</summary>
        async Task FlushAsync()
        {
            var cw = Web.CoreWebView2;
            if (cw == null) return;
            await cw.ExecuteScriptAsync("try { if (typeof flushAll === 'function') flushAll(); } catch (e) { }");
            for (int i = 0; i < 30; i++)
            {
                var busy = await cw.ExecuteScriptAsync("(typeof pendingSaves === 'function' && pendingSaves()) ? 1 : 0");
                if (busy != "1") return;
                await Task.Delay(100);
            }
        }

        public async Task ExitCloseAsync()
        {
            try { await FlushAsync(); }
            catch (Exception) { }
            _exiting = true;
            Close();
        }

        // ---------- size and place, kept in pve_panel.ini ----------

        void LoadBounds()
        {
            double w = PanelSettings.GetNum("win_w", 0), h = PanelSettings.GetNum("win_h", 0);
            double x = PanelSettings.GetNum("win_x", double.NaN), y = PanelSettings.GetNum("win_y", double.NaN);
            if (w >= MinWidth && h >= MinHeight)
            {
                Width = w;
                Height = h;
            }
            if (!double.IsNaN(x) && !double.IsNaN(y) &&
                x + 100 > SystemParameters.VirtualScreenLeft && y + 50 > SystemParameters.VirtualScreenTop &&
                x + 100 < SystemParameters.VirtualScreenLeft + SystemParameters.VirtualScreenWidth &&
                y + 50 < SystemParameters.VirtualScreenTop + SystemParameters.VirtualScreenHeight)
            {
                WindowStartupLocation = WindowStartupLocation.Manual;
                Left = x;
                Top = y;
            }
            if (PanelSettings.GetBool("win_max", false)) WindowState = WindowState.Maximized;
        }

        void SaveBounds()
        {
            var r = WindowState == WindowState.Normal ? new Rect(Left, Top, Width, Height) : RestoreBounds;
            if (r.Width <= 0 || r.Height <= 0) return;
            PanelSettings.SetNums(("win_x", r.Left), ("win_y", r.Top), ("win_w", r.Width), ("win_h", r.Height),
                ("win_max", WindowState == WindowState.Maximized ? 1 : 0));
        }
    }
}
