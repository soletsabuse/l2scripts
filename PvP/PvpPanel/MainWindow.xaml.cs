using System;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Windows;
using Microsoft.Web.WebView2.Core;

namespace PvpPanel
{
    /// <summary>The panel window: the server's page (pvp.html) inside WebView2. Closing hides it to the tray and unloads
    /// the page - its live events close, so the bots stop building their state (they do it only while a page watches).</summary>
    public partial class MainWindow : Window
    {
        readonly Func<Task> _startServer;
        bool _up, _exiting, _webFailed, _reload = true;

        public MainWindow(Func<Task> startServer)
        {
            InitializeComponent();
            _startServer = startServer;
            Icon = Tray.WindowIcon;
            Web.DefaultBackgroundColor = System.Drawing.Color.FromArgb(9, 12, 17);
            LoadBounds();
        }

        internal async void ShowPanel(ServerStatus st)
        {
            _up = st.Up;
            _error = st.Error;
            if (!IsVisible) Show();
            if (WindowState == WindowState.Minimized) WindowState = WindowState.Normal;
            Activate();
            await LoadAsync();
        }

        /// <summary>The tray's status every 2 s: the server went down -> the "not running" pane; back up -> the page
        /// again (a page loaded while it was down is an error page).</summary>
        internal void OnStatus(ServerStatus st)
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
            // links that open a new window go to the browser
            cw.NewWindowRequested += (s, e) =>
            {
                e.Handled = true;
                Tray.OpenExternal(e.Uri);
            };
        }

        string _error = "";

        void ShowDown(bool starting)
        {
            if (_webFailed) return;
            DownTitle.Text = starting ? "Starting the server…" : "PvP server not running";
            DownText.Text = "The server is built into the panel (ports 7790 and 7791). The bots work without it - their keys read the " +
                            "profiles themselves - but the page and switching profiles on the fly need it." +
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

        /// <summary>The page off (its live events closed): the bots stop building their state for nobody. A profile edit
        /// still waiting to be saved (the page saves a moment after the last change) is saved first.</summary>
        async void Unload()
        {
            _reload = true;
            try
            {
                await FlushAsync();
                if (!IsVisible) Web.CoreWebView2?.Navigate("about:blank");   // (shown again meanwhile: kept)
            }
            catch (Exception) { }
        }

        /// <summary>The page's pending save done now (saveNow of pvp.html), waited for up to 2 s.</summary>
        async Task FlushAsync()
        {
            var cw = Web.CoreWebView2;
            if (cw == null) return;
            await cw.ExecuteScriptAsync("try { if (typeof saveNow === 'function' && (saveT || saving)) saveNow(); } catch (e) { }");
            for (int i = 0; i < 20; i++)
            {
                var busy = await cw.ExecuteScriptAsync("(typeof saveT !== 'undefined' && (saveT || saving)) ? 1 : 0");
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

        // ---------- size and place, kept in pvp_panel.ini ----------

        void LoadBounds()
        {
            double w = PanelSettings.GetNum("win_w", 0), h = PanelSettings.GetNum("win_h", 0);
            double x = PanelSettings.GetNum("win_x", double.NaN), y = PanelSettings.GetNum("win_y", double.NaN);
            if (w >= MinWidth && h >= MinHeight)
            {
                Width = w;
                Height = h;
            }
            // only where a screen is now (a monitor taken away: centred as at the first start)
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
