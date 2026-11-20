using System;
using System.IO;
using System.Linq;
using System.Threading;
using System.Windows;
using System.Windows.Threading;

namespace EnchPanel
{
    /// <summary>EnchPanel: one copy per user (a second start shows the panel of the first and quits). Started with
    /// --tray (the Windows autostart) it sits in the tray; else the panel opens too.</summary>
    public partial class App : Application
    {
        Mutex? _one;
        bool _owner;
        EventWaitHandle? _showEvt;
        RegisteredWaitHandle? _wait;
        Tray? _tray;

        void OnStartup(object sender, StartupEventArgs e)
        {
            _one = new Mutex(true, @"Local\EnchPanel.One", out _owner);
            _showEvt = new EventWaitHandle(false, EventResetMode.AutoReset, @"Local\EnchPanel.Show");
            if (!_owner)
            {
                _showEvt.Set();                // the running one shows its panel
                Shutdown();
                return;
            }
            PanelSettings.Load();
            _tray = new Tray();
            _wait = ThreadPool.RegisterWaitForSingleObject(_showEvt,
                (s, t) => Dispatcher.BeginInvoke(new Action(() => _tray?.ShowPanel())), null, -1, false);
            if (!e.Args.Any(a => string.Equals(a, "--tray", StringComparison.OrdinalIgnoreCase)))
                _tray.ShowPanel();
        }

        void OnExit(object sender, ExitEventArgs e)
        {
            _wait?.Unregister(null);
            _tray?.Dispose();
            if (_owner) _one?.ReleaseMutex();
        }

        /// <summary>An error of the panel never closes it: written to ench_panel.log next to enchant.txt.</summary>
        void OnUnhandled(object sender, DispatcherUnhandledExceptionEventArgs e)
        {
            try
            {
                File.AppendAllText(Path.Combine(Paths.EnchDir, "ench_panel.log"),
                    DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss ") + e.Exception + Environment.NewLine);
            }
            catch (Exception) { }
            e.Handled = true;
        }
    }
}
