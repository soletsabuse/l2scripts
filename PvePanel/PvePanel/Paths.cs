using System;
using System.IO;

namespace PvePanel
{
    /// <summary>Where everything lies. The PvePanel folder (Library\PvePanel) is the one that holds pve.txt - the exe
    /// folder or one above it (a build in PvePanel\bin\... finds it by going up). Everything the app writes stays in it;
    /// Library\Nav, Library\Zones and Library\Configurations are only read (maps to import, zones, bot profiles).</summary>
    static class Paths
    {
        public static string PveDir { get; } = FindPveDir();

        public static string Page => Path.Combine(PveDir, "pve.html");
        public static string NavPage => Path.Combine(PveDir, "nav.html");
        public static string PanelIni => Path.Combine(PveDir, "pve_panel.ini");
        public static string NavDir => Path.Combine(PveDir, "Nav");                 // our maps (+ cache, live files)
        public static string DataDir => Path.Combine(PveDir, "data");               // skilldb.txt, skillicons.txt
        public static string LogsDir => Path.Combine(PveDir, "Logs");
        public static string LibDir => Path.GetFullPath(Path.Combine(PveDir, ".."));
        public static string LibNavDir => Path.Combine(LibDir, "Nav");              // the old maps: import only
        public static string ZonesDir => Path.Combine(LibDir, "Zones");             // the bot's zones: read only
        public static string ProfilesDir => Path.Combine(LibDir, "Configurations"); // the bot profiles: read only
        public static string TilesDir => Path.GetFullPath(Path.Combine(LibDir, "..", "Maps"));   // the game map tiles: read only

        /// <summary>WebView2 keeps its browser data here, not next to the exe.</summary>
        public static string WebData => Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "PvePanel", "WebView2");

        public static readonly int HttpPort = int.TryParse(Environment.GetEnvironmentVariable("PVE_HTTP_PORT"), out var p) && p > 0 ? p : 7800;   // (a test: another port)
        public static readonly string PageUrl = "http://127.0.0.1:" + HttpPort + "/";

        static string FindPveDir()
        {
            var env = Environment.GetEnvironmentVariable("PVE_DIR");                // (a test: another folder)
            if (!string.IsNullOrEmpty(env) && File.Exists(Path.Combine(env, "pve.txt"))) return Path.GetFullPath(env);
            for (var d = new DirectoryInfo(AppContext.BaseDirectory); d != null; d = d.Parent)
                if (File.Exists(Path.Combine(d.FullName, "pve.txt")))
                    return d.FullName;
            return AppContext.BaseDirectory;
        }

        /// <summary>The folders the bot writes into (a script cannot make folders).</summary>
        public static void EnsureFolders()
        {
            foreach (var d in new[] { NavDir, Path.Combine(NavDir, "cache"), LogsDir })
                try { Directory.CreateDirectory(d); }
                catch (IOException) { }
                catch (UnauthorizedAccessException) { }
        }
    }
}
