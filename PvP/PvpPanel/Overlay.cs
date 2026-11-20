using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace PvpPanel
{
    /// <summary>
    /// The overlay: a small panel over the game window of each bot (the bot says its window: WIN|&lt;hwnd&gt;), shown while
    /// that game window (or the overlay) is the active one. Normally see-through for the mouse: the clicks go to the
    /// game. The hot key (Ctrl+Alt+O) or the tray menu makes it clickable: its switches change the profile / turn
    /// res-kill and assist on / off; the hot key again gives the game its focus back. Plain WPF (no browser inside):
    /// the bot's state and the profile file come straight from the panel's server.
    /// </summary>
    sealed class OverlayManager : IDisposable
    {
        const int HotkeyId = 0x5047;
        readonly PvpServer _server;
        readonly Dictionary<string, OverlayWindow> _wins = new Dictionary<string, OverlayWindow>(StringComparer.OrdinalIgnoreCase);
        readonly bool _hotkey;

        public bool Clickable { get; private set; }
        public bool HotkeyOk => _hotkey;
        public const string HotkeyText = "Ctrl+Alt+O";

        public static bool Enabled
        {
            get => PanelSettings.GetBool("overlay", true);
            set => PanelSettings.SetBool("overlay", value);
        }

        public OverlayManager(PvpServer server)
        {
            _server = server;
            ComponentDispatcher.ThreadFilterMessage += OnMessage;
            _hotkey = Native.RegisterHotKey(IntPtr.Zero, HotkeyId, Native.MOD_CONTROL | Native.MOD_ALT | Native.MOD_NOREPEAT, 0x4F);
        }

        void OnMessage(ref MSG m, ref bool handled)
        {
            if (m.message == Native.WM_HOTKEY && (int)m.wParam == HotkeyId)
            {
                SetClickable(!Clickable);
                handled = true;
            }
        }

        public void SetClickable(bool on)
        {
            var fg = Native.GetForegroundWindow();
            Clickable = on;
            foreach (var w in _wins.Values) w.SetClickable(on);
            if (!on)
            {
                var back = _wins.Values.FirstOrDefault(w => w.Hwnd == fg);   // the overlay had the focus: its game gets it back
                if (back != null) Native.SetForegroundWindow(back.Game);
            }
        }

        /// <summary>The bots now: an overlay for each one that said its window; the others closed.</summary>
        public void Update(ServerStatus st)
        {
            var want = Enabled && st.Up ? st.Windows : new Dictionary<string, long>();
            foreach (var ch in _wins.Keys.ToList())
                if (!want.TryGetValue(ch, out var h) || h == 0 || (long)_wins[ch].Game != h)
                {
                    _wins[ch].Close();
                    _wins.Remove(ch);
                }
            foreach (var (ch, h) in want)
            {
                if (h == 0 || _wins.ContainsKey(ch)) continue;
                var w = new OverlayWindow(_server, ch, new IntPtr(h), Clickable);
                _wins[ch] = w;
                w.Show();
            }
            _server.SetOverlayWatch(_wins.Count > 0);     // the bots send their state while an overlay shows them
        }

        public void Dispose()
        {
            ComponentDispatcher.ThreadFilterMessage -= OnMessage;
            if (_hotkey) Native.UnregisterHotKey(IntPtr.Zero, HotkeyId);
            foreach (var w in _wins.Values) w.Close();
            _wins.Clear();
        }
    }

    /// <summary>One overlay: a see-through window kept at the top right of its game window.</summary>
    sealed class OverlayWindow : Window
    {
        static readonly Brush CText = B(0xE6, 0xEB, 0xF3), CText2 = B(0xC2, 0xCB, 0xD9), CMuted = B(0x88, 0x93, 0xA5), CDim = B(0x5B, 0x66, 0x78),
            COk = B(0x45, 0xD0, 0x9E), CWarn = B(0xF2, 0xB1, 0x4C), CHint = B(0x9C, 0xC9, 0xFF), CKey = B(0xCF, 0xE3, 0xFF),
            CKeyBg = B(0x5A, 0xA9, 0xFF, 0x24), CKeyLine = B(0x5A, 0xA9, 0xFF, 0x59), CNoKeyLine = B(255, 255, 255, 0x1A),
            CTrackOff = B(255, 255, 255, 0x21), CTrackOn = B(0x45, 0xD0, 0x9E, 0x80), CKnobOff = B(0x8F, 0x99, 0xA8), CKnobOn = B(255, 255, 255),
            CHover = B(255, 255, 255, 0x12), CLine = B(255, 255, 255, 0x12), CFoe = B(0xFF, 0x8A, 0x7A), CCell = B(255, 255, 255, 0x0D);
        readonly PvpServer _srv;
        readonly string _char;
        readonly Border _box = new Border();
        readonly StackPanel _body = new StackPanel();
        readonly DispatcherTimer _follow, _data;
        readonly Dictionary<string, DateTime> _busy = new Dictionary<string, DateTime>(StringComparer.OrdinalIgnoreCase);
        bool _clickable, _shown;
        string _sig = "", _profPath = "", _profText = "";
        DateTime _profMod;

        public IntPtr Game { get; }
        public IntPtr Hwnd { get; private set; }

        public OverlayWindow(PvpServer srv, string ch, IntPtr game, bool clickable)
        {
            _srv = srv;
            _char = ch;
            Game = game;
            _clickable = clickable;
            Title = "PvP overlay - " + ch;
            WindowStyle = WindowStyle.None;
            AllowsTransparency = true;
            Background = Brushes.Transparent;
            ResizeMode = ResizeMode.NoResize;
            ShowInTaskbar = false;
            ShowActivated = false;
            Topmost = true;
            Width = 286;
            SizeToContent = SizeToContent.Height;
            Left = -3000;
            Top = -3000;
            FontFamily = new FontFamily("Segoe UI");
            FontSize = 12.5;
            Foreground = CText;
            TextOptions.SetTextFormattingMode(this, TextFormattingMode.Display);
            _box.CornerRadius = new CornerRadius(12);
            _box.Padding = new Thickness(10, 9, 10, 8);
            _box.BorderThickness = new Thickness(1);
            _box.Child = _body;
            Content = _box;
            Look();
            SourceInitialized += (s, e) =>
            {
                Hwnd = new WindowInteropHelper(this).Handle;
                Styles();
            };
            _follow = new DispatcherTimer(DispatcherPriority.Background) { Interval = TimeSpan.FromMilliseconds(120) };
            _follow.Tick += (s, e) => Follow();
            _follow.Start();
            _data = new DispatcherTimer(DispatcherPriority.Background) { Interval = TimeSpan.FromMilliseconds(300) };
            _data.Tick += (s, e) => Draw(false);
            _data.Start();
            Closed += (s, e) =>
            {
                _follow.Stop();
                _data.Stop();
            };
            Draw(true);
        }

        static SolidColorBrush B(byte r, byte g, byte b, byte a = 255)
        {
            var x = new SolidColorBrush(Color.FromArgb(a, r, g, b));
            x.Freeze();
            return x;
        }

        void Look()
        {
            _box.Background = _clickable ? B(13, 17, 25, 242) : B(9, 12, 17, 150);
            _box.BorderBrush = _clickable ? B(90, 169, 255, 140) : B(255, 255, 255, 22);
            _box.Opacity = _clickable ? 1 : 0.9;
        }

        /// <summary>See-through for the mouse (and never active) unless clickable.</summary>
        void Styles()
        {
            if (Hwnd == IntPtr.Zero) return;
            var ex = Native.GetWindowLongPtr(Hwnd, Native.GWL_EXSTYLE).ToInt64();
            ex |= Native.WS_EX_TOOLWINDOW | Native.WS_EX_LAYERED;
            if (_clickable) ex &= ~(Native.WS_EX_TRANSPARENT | Native.WS_EX_NOACTIVATE);
            else ex |= Native.WS_EX_TRANSPARENT | Native.WS_EX_NOACTIVATE;
            Native.SetWindowLongPtr(Hwnd, Native.GWL_EXSTYLE, new IntPtr(ex));
        }

        public void SetClickable(bool on)
        {
            _clickable = on;
            Styles();
            Look();
            Draw(true);
        }

        /// <summary>Shown while its game window (or itself) is the active one, at the top right of the game's client area.</summary>
        void Follow()
        {
            if (Hwnd == IntPtr.Zero) return;
            var fg = Native.GetForegroundWindow();
            var show = Native.IsWindow(Game) && Native.IsWindowVisible(Game) && !Native.IsIconic(Game) && (fg == Game || fg == Hwnd);
            if (!show)
            {
                if (_shown) Native.ShowWindow(Hwnd, Native.SW_HIDE);
                _shown = false;
                return;
            }
            if (!Native.GetClientRect(Game, out var rc)) return;
            var pt = new Native.POINT { X = rc.Right, Y = 0 };
            Native.ClientToScreen(Game, ref pt);
            var src = PresentationSource.FromVisual(this);
            var sx = src?.CompositionTarget?.TransformToDevice.M11 ?? 1.0;
            var w = (int)Math.Round(ActualWidth * sx);
            Native.SetWindowPos(Hwnd, Native.HWND_TOPMOST, pt.X - w - 10, pt.Y + 10, 0, 0,
                Native.SWP_NOSIZE | Native.SWP_NOACTIVATE | Native.SWP_SHOWWINDOW);
            _shown = true;
        }

        // ---------- what it shows ----------

        string ReadProfile(string id)
        {
            var path = System.IO.Path.Combine(Paths.ProfilesDir, id + ".pvp");
            DateTime mod;
            try { mod = File.GetLastWriteTimeUtc(path); }
            catch (Exception) { return ""; }
            if (path != _profPath || mod != _profMod)
            {
                _profPath = path;
                _profMod = mod;
                _profText = ProfileFiles.ReadText(path) ?? "";
            }
            return _profText;
        }

        void Draw(bool force)
        {
            var (json, age) = _srv.StateOf(_char);
            var fresh = json != null && age < 6;
            string id = "", pname = "", rk = "", lead = "";
            int rkAgo = 0, link = -1, rtt = -1;
            var cnt = new int[6];                                   // on party, on me, clan alive, clan dead, others alive, others dead
            var live = new List<string>();
            if (fresh)
            {
                try
                {
                    using var d = JsonDocument.Parse(json!);
                    if (d.RootElement.TryGetProperty("profile", out var pr))
                    {
                        id = Str(pr, "id");
                        pname = Str(pr, "name");
                        if (pr.TryGetProperty("live", out var lv) && lv.ValueKind == JsonValueKind.Array)
                            foreach (var x in lv.EnumerateArray()) live.Add((x.GetString() ?? "").ToLowerInvariant());
                        if (pr.TryGetProperty("rk", out var r))
                        {
                            rk = Str(r, "t");
                            rkAgo = Int(r, "ago");
                        }
                    }
                    if (d.RootElement.TryGetProperty("cnt", out var c))
                    {
                        cnt[0] = Math.Max(0, Int(c, "onus"));
                        cnt[1] = Math.Max(0, Int(c, "onme"));
                        if (c.TryGetProperty("clan", out var ca) && ca.ValueKind == JsonValueKind.Array && ca.GetArrayLength() == 2) { cnt[2] = ca[0].GetInt32(); cnt[3] = ca[1].GetInt32(); }
                        if (c.TryGetProperty("other", out var oa) && oa.ValueKind == JsonValueKind.Array && oa.GetArrayLength() == 2) { cnt[4] = oa[0].GetInt32(); cnt[5] = oa[1].GetInt32(); }
                    }
                    if (d.RootElement.TryGetProperty("net", out var net))
                    {
                        link = Int(net, "link");
                        rtt = Int(net, "rtt");
                        lead = Str(net, "lead");
                    }
                }
                catch (JsonException) { fresh = false; }
            }
            var text = fresh && ProfileFiles.ValidId(id) ? ReadProfile(id) : "";
            foreach (var k in _busy.Where(kv => (DateTime.UtcNow - kv.Value).TotalMilliseconds > 1500).Select(kv => kv.Key).ToList()) _busy.Remove(k);
            var sig = string.Join("\u0001", fresh, id, pname, string.Join(",", live), link, rtt, rk, rkAgo / 1000, text.GetHashCode(), _clickable, string.Join(",", _busy.Keys), string.Join(",", cnt), lead);
            if (!force && sig == _sig) return;
            _sig = sig;
            _lead = lead;
            Build(fresh, id, pname, text, live, link, rtt, rk, rkAgo, cnt);
        }
        string _lead = "";

        static string Str(JsonElement e, string k) => e.TryGetProperty(k, out var v) && v.ValueKind == JsonValueKind.String ? v.GetString() ?? "" : "";
        static int Int(JsonElement e, string k) => e.TryGetProperty(k, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out var n) ? n : -1;

        void Build(bool fresh, string id, string pname, string text, List<string> live, int link, int rtt, string rk, int rkAgo, int[] cnt)
        {
            _body.Children.Clear();
            // the head: the character, the profile, the relay
            var hd = new DockPanel { LastChildFill = true };
            var dot = new Ellipse { Width = 7, Height = 7, Fill = !fresh ? CDim : link == 0 ? CWarn : COk, Margin = new Thickness(0, 0, 7, 0), VerticalAlignment = VerticalAlignment.Center };
            DockPanel.SetDock(dot, Dock.Left);
            hd.Children.Add(dot);
            if (fresh && link >= 0)
            {
                var srv = new TextBlock { Text = link == 1 ? (rtt >= 0 ? rtt + " ms" : "server") : "no server", Foreground = CMuted, FontSize = 11, VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(6, 0, 0, 0) };
                DockPanel.SetDock(srv, Dock.Right);
                hd.Children.Add(srv);
            }
            var title = new TextBlock { VerticalAlignment = VerticalAlignment.Center, TextTrimming = TextTrimming.CharacterEllipsis };
            title.Inlines.Add(new Run(_char) { FontWeight = FontWeights.Bold });
            if (pname.Length > 0) title.Inlines.Add(new Run("  · " + pname) { Foreground = CMuted, FontSize = 11.5 });
            hd.Children.Add(title);
            _body.Children.Add(hd);
            if (!fresh) { _body.Children.Add(Msg("pvp_focus.txt is not running on " + _char + ".")); return; }
            _body.Children.Add(Counts(cnt));
            if (text.Length == 0) { _body.Children.Add(Msg("Profile «" + id + "» not found.")); return; }

            var rows = new StackPanel { Margin = new Thickness(0, 7, 0, 0) };
            foreach (var g in GroupsOf(text))
            {
                var name = g.TryGetValue("name", out var nm) && nm.Length > 0 ? nm : "group " + (g.Index + 1);
                var on = !(g.TryGetValue("on", out var o) && o == "0");
                var mode = g.TryGetValue("mode", out var md) ? md : "class";
                g.TryGetValue("key", out var key);
                var gi = g.Index;
                if ((mode == "reskill" || mode == "assist" || mode == "antiaggro") && on)
                {
                    var isOn = live.Contains(name.ToLowerInvariant());
                    string? note = null;
                    if (mode == "assist" && g.TryGetValue("assist_src", out var src) && src == "net")
                        note = g.TryGetValue("assist", out var asn) && asn.StartsWith("@lead", StringComparison.OrdinalIgnoreCase)
                            ? (_lead.Length > 0 ? "→ " + _lead : "no leader") : "via server";
                    rows.Children.Add(Row(key, name, note, isOn ? "ON" : "OFF", isOn ? COk : CWarn, isOn, _busy.ContainsKey(name), false, () =>
                    {
                        _busy[name] = DateTime.UtcNow;
                        _ = _srv.PressAsync(_char, name);          // as its key: on / off in the bot
                        Draw(true);
                    }));
                }
                else
                {
                    rows.Children.Add(Row(key, name, mode == "auto" ? "by weight" : null, null, null, on, false, !on,
                        () => Save(id, gi, "on", on ? "0" : "1")));
                }
                if (mode == "auto" && on)
                {
                    var ra = g.TryGetValue("res_auto", out var r) && r == "1";
                    if (!ra) rows.Children.Add(SubRow("Res-kill by itself", false, () => Save(id, gi, "res_auto", "1")));
                    else
                    {
                        // on / off in this bot (as its res-kill key), not in the profile
                        var rkOn = live.Contains(name.ToLowerInvariant());
                        g.TryGetValue("res_key", out var rkKey);
                        var lbl = "Res-kill" + (string.IsNullOrEmpty(rkKey) ? " by itself" : " · " + rkKey);
                        rows.Children.Add(SubRow(lbl, rkOn, () =>
                        {
                            _ = _srv.PressAsync(_char, name, true);
                            Draw(true);
                        }));
                    }
                }
            }
            if (rows.Children.Count == 0) rows.Children.Add(Msg("No groups in this profile."));
            _body.Children.Add(rows);

            var ft = new StackPanel { Margin = new Thickness(0, 6, 0, 0) };
            var line = new Border { Height = 1, Background = CLine, Margin = new Thickness(0, 0, 0, 5) };
            ft.Children.Add(line);
            if (rk.Length > 0)
            {
                var t = new TextBlock { FontSize = 11, Foreground = CMuted, TextTrimming = TextTrimming.CharacterEllipsis };
                t.Inlines.Add(new Run("Res-kill: "));
                t.Inlines.Add(new Run(rk) { Foreground = CText2, FontWeight = FontWeights.SemiBold });
                t.Inlines.Add(new Run(" · " + Math.Max(0, rkAgo / 1000) + " s ago"));
                ft.Children.Add(t);
            }
            ft.Children.Add(new TextBlock
            {
                FontSize = 11,
                Foreground = _clickable ? CHint : CDim,
                Text = _clickable ? "Clickable · " + OverlayManager.HotkeyText + ": back to the game" : OverlayManager.HotkeyText + ": make it clickable",
            });
            _body.Children.Add(ft);
        }

        // three cells: enemies holding the party (and you), the clan alive † dead, the others alive † dead
        static FrameworkElement Counts(int[] c)
        {
            var g = new System.Windows.Controls.Primitives.UniformGrid { Columns = 3, Margin = new Thickness(0, 7, 0, 0) };
            FrameworkElement Cell(string cap, TextBlock val, string tip)
            {
                var sp = new StackPanel();
                sp.Children.Add(new TextBlock { Text = cap, FontSize = 9.5, FontWeight = FontWeights.Bold, Foreground = CDim });
                sp.Children.Add(val);
                return new Border { Background = CCell, CornerRadius = new CornerRadius(7), Padding = new Thickness(7, 4, 7, 4), Margin = new Thickness(0, 0, 4, 0), Child = sp, ToolTip = tip };
            }
            TextBlock Val() => new TextBlock { FontSize = 15, FontWeight = FontWeights.Bold, Foreground = CText };
            var on = Val();
            on.Inlines.Add(new Run(c[0].ToString()) { Foreground = c[0] > 0 ? CFoe : CMuted });
            if (c[1] > 0) on.Inlines.Add(new Run("  you " + c[1]) { FontSize = 10.5, FontWeight = FontWeights.SemiBold, Foreground = CFoe });
            var cl = Val();
            cl.Inlines.Add(new Run(c[2].ToString()) { Foreground = COk });
            cl.Inlines.Add(new Run("  †" + c[3]) { FontSize = 11, FontWeight = FontWeights.SemiBold, Foreground = CMuted });
            var ot = Val();
            ot.Inlines.Add(new Run(c[4].ToString()));
            ot.Inlines.Add(new Run("  †" + c[5]) { FontSize = 11, FontWeight = FontWeights.SemiBold, Foreground = CMuted });
            g.Children.Add(Cell("ON PARTY", on, "Not of your party / clan / alliance, holding a party member in target now (you: on you)"));
            g.Children.Add(Cell("CLAN", cl, "Your clan in sight: alive † dead"));
            g.Children.Add(Cell("OTHERS", ot, "Everyone else in sight: alive † dead"));
            return g;
        }

        static TextBlock Msg(string t) => new TextBlock { Text = t, Foreground = CMuted, Margin = new Thickness(2, 6, 2, 2), TextWrapping = TextWrapping.Wrap };

        void Save(string id, int gi, string field, string val)
        {
            var t = SetField(_profText, gi, field, val);
            if (t == null) return;
            _profText = t;
            _ = _srv.SaveProfileAsync(id, t);               // the bots read it (RELOAD), the pages get it
            Draw(true);
        }

        FrameworkElement Row(string? key, string name, string? note, string? st, Brush? stColor, bool on, bool busy, bool dim, Action click)
        {
            var g = new Grid { MinHeight = 25, Background = Brushes.Transparent, Margin = new Thickness(0, 1, 0, 0) };
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            var kc = new Border
            {
                MinWidth = 20, Height = 18, CornerRadius = new CornerRadius(5), BorderThickness = new Thickness(1), Padding = new Thickness(5, 0, 5, 0),
                Background = string.IsNullOrEmpty(key) ? Brushes.Transparent : CKeyBg, BorderBrush = string.IsNullOrEmpty(key) ? CNoKeyLine : CKeyLine,
                Margin = new Thickness(6, 0, 7, 0), VerticalAlignment = VerticalAlignment.Center,
                Child = new TextBlock { Text = string.IsNullOrEmpty(key) ? "–" : key, FontSize = 10.5, FontWeight = FontWeights.Bold, Foreground = string.IsNullOrEmpty(key) ? CDim : CKey, HorizontalAlignment = HorizontalAlignment.Center, VerticalAlignment = VerticalAlignment.Center },
            };
            Grid.SetColumn(kc, 0);
            g.Children.Add(kc);
            var nm = new TextBlock { VerticalAlignment = VerticalAlignment.Center, TextTrimming = TextTrimming.CharacterEllipsis, Foreground = dim ? CDim : CText2 };
            nm.Inlines.Add(new Run(name));
            if (note != null) nm.Inlines.Add(new Run("  " + note) { Foreground = CMuted, FontSize = 10.5 });
            Grid.SetColumn(nm, 1);
            g.Children.Add(nm);
            if (st != null)
            {
                var s = new TextBlock { Text = st, Foreground = stColor, FontSize = 10, FontWeight = FontWeights.ExtraBold, VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(6, 0, 6, 0) };
                Grid.SetColumn(s, 2);
                g.Children.Add(s);
            }
            var sw = Switch(on, busy);
            sw.Margin = new Thickness(4, 0, 6, 0);
            Grid.SetColumn(sw, 3);
            g.Children.Add(sw);
            Clickable(g, click);
            return g;
        }

        FrameworkElement SubRow(string text, bool on, Action click)
        {
            var g = new Grid { MinHeight = 22, Background = Brushes.Transparent };
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            var t = new TextBlock { Text = text, Foreground = CMuted, FontSize = 11.5, VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(34, 0, 0, 0) };
            g.Children.Add(t);
            var sw = Switch(on, false);
            sw.Margin = new Thickness(4, 0, 6, 0);
            Grid.SetColumn(sw, 1);
            g.Children.Add(sw);
            Clickable(g, click);
            return g;
        }

        void Clickable(Grid g, Action click)
        {
            var bg = new Border { CornerRadius = new CornerRadius(7), Background = Brushes.Transparent };
            Grid.SetColumnSpan(bg, 4);
            g.Children.Insert(0, bg);
            if (!_clickable) return;
            g.Cursor = Cursors.Hand;
            g.MouseEnter += (s, e) => bg.Background = CHover;
            g.MouseLeave += (s, e) => bg.Background = Brushes.Transparent;
            g.MouseLeftButtonUp += (s, e) => click();
        }

        static FrameworkElement Switch(bool on, bool busy)
        {
            var g = new Grid { Width = 28, Height = 16, VerticalAlignment = VerticalAlignment.Center, Opacity = busy ? 0.5 : 1 };
            g.Children.Add(new Border { CornerRadius = new CornerRadius(8), Background = on ? CTrackOn : CTrackOff });
            g.Children.Add(new Ellipse { Width = 12, Height = 12, Fill = on ? CKnobOn : CKnobOff, HorizontalAlignment = on ? HorizontalAlignment.Right : HorizontalAlignment.Left, Margin = new Thickness(2, 0, 2, 0) });
            return g;
        }

        // ---------- the profile text: its groups, one field of one group ----------

        sealed class Group : Dictionary<string, string>
        {
            public int Index;
        }

        static List<Group> GroupsOf(string text)
        {
            var list = new List<Group>();
            Group? g = null;
            foreach (var raw in text.Split('\n'))
            {
                var l = raw.Trim();
                if (l == "[group]")
                {
                    g = new Group { Index = list.Count };
                    list.Add(g);
                    continue;
                }
                if (g == null || l.Length == 0 || l[0] == ';') continue;
                var k = l.IndexOf('=');
                if (k > 0) g[l.Substring(0, k)] = l.Substring(k + 1);
            }
            return list;
        }

        /// <summary>field= of group gi set to val (the line added after [group] when missing); null: no such group.</summary>
        static string? SetField(string text, int gi, string field, string val)
        {
            var lines = text.Replace("\r\n", "\n").Split('\n').ToList();
            int n = -1, i = 0;
            for (; i < lines.Count; i++)
                if (lines[i].Trim() == "[group]" && ++n == gi) break;
            if (i >= lines.Count) return null;
            for (var j = i + 1; j < lines.Count && lines[j].Trim() != "[group]"; j++)
                if (lines[j].StartsWith(field + "=", StringComparison.Ordinal))
                {
                    lines[j] = field + "=" + val;
                    return string.Join("\r\n", lines);
                }
            lines.Insert(i + 1, field + "=" + val);
            return string.Join("\r\n", lines);
        }
    }

    static class Native
    {
        public const int GWL_EXSTYLE = -20, WM_HOTKEY = 0x0312, SW_HIDE = 0;
        public const long WS_EX_TRANSPARENT = 0x20, WS_EX_TOOLWINDOW = 0x80, WS_EX_LAYERED = 0x80000, WS_EX_NOACTIVATE = 0x08000000;
        public const uint MOD_ALT = 0x1, MOD_CONTROL = 0x2, MOD_NOREPEAT = 0x4000;
        public const uint SWP_NOSIZE = 0x1, SWP_NOACTIVATE = 0x10, SWP_SHOWWINDOW = 0x40;
        public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);

        [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
        [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }

        [DllImport("user32.dll", EntryPoint = "GetWindowLongPtrW")] public static extern IntPtr GetWindowLongPtr(IntPtr h, int i);
        [DllImport("user32.dll", EntryPoint = "SetWindowLongPtrW")] public static extern IntPtr SetWindowLongPtr(IntPtr h, int i, IntPtr v);
        [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
        [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
        [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
        [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
        [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
        [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref POINT p);
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
        [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
        [DllImport("user32.dll")] public static extern bool RegisterHotKey(IntPtr h, int id, uint mods, uint vk);
        [DllImport("user32.dll")] public static extern bool UnregisterHotKey(IntPtr h, int id);
    }
}
