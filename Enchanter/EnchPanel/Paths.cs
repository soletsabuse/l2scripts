using System;
using System.IO;

namespace EnchPanel
{
    /// <summary>Where everything lies: the enchanter folder (Library\Enchanter) is the one that holds enchant.txt - the
    /// exe folder or one above it (a build in EnchPanel\bin\... finds it by going up).</summary>
    static class Paths
    {
        public static string EnchDir { get; } = FindEnchDir();

        public static string Page => Path.Combine(EnchDir, "enchant.html");
        public static string PanelIni => Path.Combine(EnchDir, "ench_panel.ini");
        public static string LogsDir => Path.GetFullPath(Path.Combine(EnchDir, "..", "Logs"));

        /// <summary>WebView2 keeps its browser data here, not next to the exe (the Library folder stays clean).</summary>
        public static string WebData => Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "EnchPanel", "WebView2");

        public static readonly int HttpPort = int.TryParse(Environment.GetEnvironmentVariable("ENCH_HTTP_PORT"), out var p) && p > 0 ? p : 7780;   // (a test: another port)
        public static readonly string PageUrl = "http://127.0.0.1:" + HttpPort + "/";

        static string FindEnchDir()
        {
            for (var d = new DirectoryInfo(AppContext.BaseDirectory); d != null; d = d.Parent)
                if (File.Exists(Path.Combine(d.FullName, "enchant.txt")))
                    return d.FullName;
            return AppContext.BaseDirectory;
        }
    }
}
