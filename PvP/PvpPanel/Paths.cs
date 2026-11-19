using System;
using System.IO;

namespace PvpPanel
{
    /// <summary>Where everything lies: the PvP folder (Library\PvP) is the one that holds pvp_server.py - the exe folder
    /// or one above it (a build in PvpPanel\bin\... finds it by going up).</summary>
    static class Paths
    {
        public static string PvpDir { get; } = FindPvpDir();

        public static string Server => Path.Combine(PvpDir, "pvp_server.py");
        public static string ProfilesDir => Path.Combine(PvpDir, "profiles");
        public static string SoundsDir => Path.Combine(PvpDir, "sounds");          // the res-kill sounds (.wav)
        public static string Ini => Path.Combine(PvpDir, "pvp.ini");
        public static string PanelIni => Path.Combine(PvpDir, "pvp_panel.ini");
        public static string Page => Path.Combine(PvpDir, "pvp.html");
        public static string ServerLog => Path.Combine(PvpDir, "pvp_server.log");
        public static string BindsDir => Path.GetFullPath(Path.Combine(PvpDir, "..", "Binds"));     // the equip binds (a key clash warning)
        public static string SkillDb => Path.GetFullPath(Path.Combine(PvpDir, "..", "Nav", "skilldb.txt"));   // id|oper|magic|range|name

        /// <summary>WebView2 keeps its browser data here, not next to the exe (the Library folder stays clean).</summary>
        public static string WebData => Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "PvpPanel", "WebView2");

        public const string PageUrl = "http://127.0.0.1:7790/";

        static string FindPvpDir()
        {
            for (var d = new DirectoryInfo(AppContext.BaseDirectory); d != null; d = d.Parent)
                if (File.Exists(Path.Combine(d.FullName, "pvp_server.py")))
                    return d.FullName;
            return AppContext.BaseDirectory;
        }
    }
}
