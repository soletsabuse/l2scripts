using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using Microsoft.Win32;

namespace PvpPanel
{
    /// <summary>The app's own settings: pvp_panel.ini next to pvp.ini (key=value, utf-8); autostart: the Run key of the user.</summary>
    static class PanelSettings
    {
        static readonly Dictionary<string, string> Values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        const string RunKey = @"Software\Microsoft\Windows\CurrentVersion\Run";
        const string RunName = "PvpPanel";

        public static void Load()
        {
            Values.Clear();
            try
            {
                foreach (var raw in File.ReadAllLines(Paths.PanelIni, Encoding.UTF8))
                {
                    var line = raw.Trim();
                    if (line.Length == 0 || line.StartsWith(";")) continue;
                    var i = line.IndexOf('=');
                    if (i > 0) Values[line.Substring(0, i).Trim()] = line.Substring(i + 1).Trim();
                }
            }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
        }

        static void Save()
        {
            var sb = new StringBuilder("; PvpPanel (the tray app of PvP focus): its own settings\r\n");
            foreach (var kv in Values) sb.Append(kv.Key).Append('=').Append(kv.Value).Append("\r\n");
            try { File.WriteAllText(Paths.PanelIni, sb.ToString(), new UTF8Encoding(false)); }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
        }

        public static bool GetBool(string key, bool def) =>
            Values.TryGetValue(key, out var v) ? v == "1" : def;

        public static void SetBool(string key, bool v)
        {
            Values[key] = v ? "1" : "0";
            Save();
        }

        public static double GetNum(string key, double def) =>
            Values.TryGetValue(key, out var v) && double.TryParse(v, NumberStyles.Float, CultureInfo.InvariantCulture, out var d) ? d : def;

        public static void SetNums(params (string Key, double Value)[] items)
        {
            foreach (var (k, v) in items) Values[k] = v.ToString("0.##", CultureInfo.InvariantCulture);
            Save();
        }

        // bot in / out: a balloon of the tray icon
        public static bool NotifyBots
        {
            get => GetBool("notify_bots", true);
            set => SetBool("notify_bots", value);
        }

        public static bool AutoStart
        {
            get
            {
                using var k = Registry.CurrentUser.OpenSubKey(RunKey);
                return k?.GetValue(RunName) is string s && s.Length > 0;
            }
            set
            {
                using var k = Registry.CurrentUser.CreateSubKey(RunKey);
                if (value) k.SetValue(RunName, "\"" + Environment.ProcessPath + "\" --tray");   // at logon: the tray only
                else k.DeleteValue(RunName, false);
            }
        }
    }
}
