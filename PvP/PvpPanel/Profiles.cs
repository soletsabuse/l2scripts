using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;

namespace PvpPanel
{
    sealed record ProfileInfo(string Id, string Name);

    /// <summary>The profile files: profiles\&lt;id&gt;.pvp and pvp.ini, read as the script reads them (utf-8 if it is, else
    /// windows-1251), written in windows-1251 with CRLF.</summary>
    static class ProfileFiles
    {
        static readonly Regex IdRe = new Regex("^[A-Za-z0-9_-]{1,40}$");
        static readonly Encoding Utf8Strict = new UTF8Encoding(false, true);
        static Encoding? _cp1251;

        static Encoding Cp1251
        {
            get
            {
                if (_cp1251 == null)
                {
                    Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
                    _cp1251 = Encoding.GetEncoding(1251);
                }
                return _cp1251;
            }
        }

        public static bool ValidId(string id) => IdRe.IsMatch(id);

        /// <summary>A line for a bot: windows-1251 (its strings are ANSI).</summary>
        public static byte[] BotBytes(string s) => Cp1251.GetBytes(s);

        /// <summary>The bot / the files: utf-8 if it is, else windows-1251.</summary>
        public static string Decode(byte[] b)
        {
            try { return Utf8Strict.GetString(b); }
            catch (DecoderFallbackException) { return Cp1251.GetString(b); }
        }

        public static string? ReadText(string path)
        {
            byte[] b;
            try { b = File.ReadAllBytes(path); }
            catch (IOException) { return null; }
            catch (UnauthorizedAccessException) { return null; }
            return Decode(b);
        }

        /// <summary>windows-1251 with CRLF (the script reads it so); a temp file swapped in (a reader never sees half of
        /// it); the script may hold it open a moment: tried again, then written in place.</summary>
        public static void WriteText(string path, string text)
        {
            var data = Cp1251.GetBytes(text.Replace("\r\n", "\n").Replace("\n", "\r\n"));
            var tmp = path + ".tmp";
            File.WriteAllBytes(tmp, data);
            for (int i = 0; i < 20; i++)
            {
                try
                {
                    File.Move(tmp, path, true);
                    return;
                }
                catch (IOException) { Thread.Sleep(50); }
                catch (UnauthorizedAccessException) { Thread.Sleep(50); }
            }
            File.WriteAllBytes(path, data);         // still held: written in place
            try { File.Delete(tmp); }
            catch (IOException) { }
        }

        static string[] Files()
        {
            try { return Directory.GetFiles(Paths.ProfilesDir, "*.pvp"); }
            catch (IOException) { return Array.Empty<string>(); }
            catch (UnauthorizedAccessException) { return Array.Empty<string>(); }
        }

        /// <summary>Every profile: id -> its text (what the page gets).</summary>
        public static Dictionary<string, string> ReadAll()
        {
            var all = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (var f in Files())
            {
                var id = Path.GetFileNameWithoutExtension(f);
                if (!ValidId(id)) continue;
                var t = ReadText(f);
                if (t != null) all[id] = t;
            }
            return all;
        }

        /// <summary>The profiles with their names (name= of the head), by name.</summary>
        public static List<ProfileInfo> List()
        {
            var list = new List<ProfileInfo>();
            foreach (var kv in ReadAll())
            {
                var name = kv.Key;
                foreach (var raw in kv.Value.Split('\n'))
                {
                    var line = raw.Trim();
                    if (line.StartsWith("[")) break;            // the groups start: the head is over
                    if (line.StartsWith("name=", StringComparison.OrdinalIgnoreCase))
                    {
                        var v = line.Substring(5).Trim();
                        if (v.Length > 0) name = v;
                        break;
                    }
                }
                list.Add(new ProfileInfo(kv.Key, name));
            }
            list.Sort((a, b) => string.Compare(a.Name, b.Name, StringComparison.CurrentCultureIgnoreCase));
            return list;
        }

        /// <summary>active=&lt;id&gt; of pvp.ini ("main" when none).</summary>
        public static string Active()
        {
            var t = ReadText(Paths.Ini) ?? "";
            foreach (var raw in t.Split('\n'))
            {
                var line = raw.Trim();
                if (!line.StartsWith("active=", StringComparison.OrdinalIgnoreCase)) continue;
                var v = line.Substring(7).Trim();
                if (ValidId(v)) return v;
            }
            return "main";
        }

        public static void WriteActive(string id)
        {
            WriteText(Paths.Ini, "; PvP focus: the profile every character uses (Library\\PvP\\profiles\\<id>.pvp). Made in pvp.html\n" +
                                 "active=" + id + "\n");
        }
    }
}
