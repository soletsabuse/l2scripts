using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;

namespace EnchPanel
{
    /// <summary>One action of a voice command (the fast rules or the model make them).</summary>
    sealed class VAct
    {
        public string Do = "";          // start stop cryst_now range scroll stones cryst_mode delay put done_max job_on status yes no
        public int Job;                 // 1.. a range; 0: the active one
        public int From = -1, To = -1;
        public int Id;                  // a scroll's item ID
        public bool? On;
        public string Mode = "";        // cryst_mode: none done left all
        public int Ms = -1, N = -1;
        public string Query = "";       // scroll by words (the fast rules): resolved against the bag
        public List<int> Items = new List<int>();   // new_range / add_items / remove_items: item IDs of the bag
        public string Tab = "";         // ui: jobs log opts panel
        public string Name = "";        // char: a character (or «next»)

        public override string ToString()
        {
            var sb = new StringBuilder(Do);
            if (Job > 0) sb.Append(" job=").Append(Job);
            if (From >= 0) sb.Append(" from=").Append(From);
            if (To >= 0) sb.Append(" to=").Append(To);
            if (Id > 0) sb.Append(" id=").Append(Id);
            if (On != null) sb.Append(" on=").Append(On.Value ? 1 : 0);
            if (Mode.Length > 0) sb.Append(" mode=").Append(Mode);
            if (Ms >= 0) sb.Append(" ms=").Append(Ms);
            if (N >= 0) sb.Append(" n=").Append(N);
            if (Query.Length > 0) sb.Append(" q=").Append(Query);
            if (Items.Count > 0) sb.Append(" items=").Append(string.Join(",", Items));
            if (Tab.Length > 0) sb.Append(" tab=").Append(Tab);
            if (Name.Length > 0) sb.Append(" name=").Append(Name);
            return sb.ToString();
        }
    }

    /// <summary>A character's &lt;char&gt;.ench edited line by line (the rest, the order, the items: kept), windows-1251.</summary>
    sealed class EnchDoc
    {
        public readonly List<string> Lines;
        public bool Changed;
        static readonly Encoding Cp1251;

        static EnchDoc()
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            Cp1251 = Encoding.GetEncoding(1251);
        }

        public EnchDoc(string text)
        {
            Lines = text.Replace("\r\n", "\n").Split('\n').ToList();
            while (Lines.Count > 0 && Lines[^1].Trim().Length == 0) Lines.RemoveAt(Lines.Count - 1);
        }

        public static EnchDoc Load(string path)
        {
            var b = File.Exists(path) ? File.ReadAllBytes(path) : Array.Empty<byte>();
            string t;
            try { t = new UTF8Encoding(false, true).GetString(b); }
            catch (DecoderFallbackException) { t = Cp1251.GetString(b); }
            return new EnchDoc(t);
        }

        public byte[] Bytes() => Cp1251.GetBytes(string.Join("\r\n", Lines) + "\r\n");

        static bool IsJob(string l) => l.Trim().Equals("[job]", StringComparison.OrdinalIgnoreCase);

        /// <summary>The blocks: -1 the general part, then the ranges ([job]). (first line, end exclusive)</summary>
        List<(int A, int B)> Blocks()
        {
            var res = new List<(int, int)>();
            int start = 0;
            for (int i = 0; i < Lines.Count; i++)
                if (IsJob(Lines[i]))
                {
                    res.Add((start, i));
                    start = i;
                }
            res.Add((start, Lines.Count));
            return res;
        }

        public int JobCount => Lines.Count(IsJob);

        /// <summary>job -1: the general part; 0..: a range.</summary>
        public string? Get(int job, string key)
        {
            var bl = Blocks();
            if (job + 1 >= bl.Count) return null;
            var (a, b) = bl[job + 1];
            for (int i = a; i < b; i++)
            {
                var l = Lines[i];
                int e = l.IndexOf('=');
                if (e > 0 && l.Substring(0, e).Trim().Equals(key, StringComparison.OrdinalIgnoreCase)) return l.Substring(e + 1).Trim();
            }
            return null;
        }

        public int GetInt(int job, string key, int def) => int.TryParse(Get(job, key), out var v) ? v : def;

        public List<string> GetAll(int job, string key)
        {
            var res = new List<string>();
            var bl = Blocks();
            if (job + 1 >= bl.Count) return res;
            var (a, b) = bl[job + 1];
            for (int i = a; i < b; i++)
            {
                var l = Lines[i];
                int e = l.IndexOf('=');
                if (e > 0 && l.Substring(0, e).Trim().Equals(key, StringComparison.OrdinalIgnoreCase)) res.Add(l.Substring(e + 1).Trim());
            }
            return res;
        }

        public void Set(int job, string key, string val)
        {
            val = val.Replace("\r", " ").Replace("\n", " ");
            var bl = Blocks();
            if (job + 1 >= bl.Count) return;
            var (a, b) = bl[job + 1];
            for (int i = a; i < b; i++)
            {
                var l = Lines[i];
                int e = l.IndexOf('=');
                if (e > 0 && l.Substring(0, e).Trim().Equals(key, StringComparison.OrdinalIgnoreCase))
                {
                    var nl = key + "=" + val;
                    if (Lines[i] != nl)
                    {
                        Lines[i] = nl;
                        Changed = true;
                    }
                    return;
                }
            }
            AddLine(job, key + "=" + val);
        }

        /// <summary>A line at the end of a block (kind= / item= lines repeat).</summary>
        public void AddLine(int job, string line)
        {
            var bl = Blocks();
            if (job + 1 >= bl.Count) return;
            var (a, b) = bl[job + 1];
            int at = b;
            while (at > a + 1 && Lines[at - 1].Trim().Length == 0) at--;   // after the block's last line, before its blank one
            Lines.Insert(at, line);
            Changed = true;
        }

        /// <summary>The lines of a block whose key is this and whose value starts with Prefix: removed (how many).</summary>
        public int RemoveLines(int job, string key, string prefix)
        {
            var bl = Blocks();
            if (job + 1 >= bl.Count) return 0;
            var (a, b) = bl[job + 1];
            int n = 0;
            for (int i = b - 1; i >= a; i--)
            {
                var l = Lines[i];
                int e = l.IndexOf('=');
                if (e > 0 && l.Substring(0, e).Trim().Equals(key, StringComparison.OrdinalIgnoreCase) && l.Substring(e + 1).Trim().StartsWith(prefix, StringComparison.Ordinal))
                {
                    Lines.RemoveAt(i);
                    n++;
                }
            }
            if (n > 0) Changed = true;
            return n;
        }

        /// <summary>A new range at the end (as the page writes one).</summary>
        public void AddJob(IEnumerable<string> lines)
        {
            if (Lines.Count > 0 && Lines[^1].Trim().Length > 0) Lines.Add("");
            Lines.Add("[job]");
            Lines.AddRange(lines);
            Changed = true;
        }

        public void RemoveJob(int job)
        {
            var bl = Blocks();
            if (job + 1 >= bl.Count) return;
            var (a, b) = bl[job + 1];
            Lines.RemoveRange(a, b - a);
            while (Lines.Count > 0 && Lines[^1].Trim().Length == 0) Lines.RemoveAt(Lines.Count - 1);
            Changed = true;
        }
    }

    /// <summary>A thing of the bag (the bot's .ench.json "stuff" / "items").</summary>
    sealed class BagThing
    {
        public int Oid, Id, N, Ench, Type = -1;    // Type: 0 weapon, 1 armor, 2 jewelry
        public string Name = "";
        public string? Grade;
        public bool Worn;
    }

    /// <summary>What the bot of a character says now (its .ench.json) + its settings file.</summary>
    sealed class CharCtx
    {
        public string Tag = "", Name = "";
        public string EnchPath = "", StatePath = "";
        public bool Live;
        public long Hwnd;
        public int BagAgo = -1;                     // s since the bot's last whole bag (14 -> 11), -1 none yet
        public DateTime Written;                    // when the bot wrote its state (local)
        public string RunState = "";
        public JsonElement Run;
        public bool HasRun;
        public List<BagThing> Stuff = new List<BagThing>();
        public List<BagThing> Items = new List<BagThing>();
        public EnchDoc Doc = new EnchDoc("");
        public bool Running => RunState == "running";

        public static List<CharCtx> All()
        {
            var res = new List<CharCtx>();
            string[] files;
            try { files = Directory.GetFiles(Paths.EnchDir, "*.ench.json"); }
            catch (Exception) { return res; }
            foreach (var f in files)
            {
                var tag = Path.GetFileName(f);
                tag = tag.Substring(0, tag.Length - ".ench.json".Length);
                var c = new CharCtx { Tag = tag, Name = tag, StatePath = f, EnchPath = Path.Combine(Paths.EnchDir, tag + ".ench") };
                try { c.Live = (DateTime.UtcNow - File.GetLastWriteTimeUtc(f)).TotalMilliseconds < 6000; }
                catch (Exception) { }
                c.ReadState();
                res.Add(c);
            }
            return res;
        }

        public void ReadState()
        {
            try
            {
                byte[] b;
                using (var fs = new FileStream(StatePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                {
                    var ms = new MemoryStream();
                    fs.CopyTo(ms);
                    b = ms.ToArray();
                }
                string text;
                try { text = new UTF8Encoding(false, true).GetString(b); }
                catch (DecoderFallbackException) { text = Encoding.GetEncoding(1251).GetString(b); }
                using var doc = JsonDocument.Parse(text);
                var r = doc.RootElement;
                if (r.TryGetProperty("char", out var ch) && ch.ValueKind == JsonValueKind.String) Name = ch.GetString() ?? Tag;
                if (r.TryGetProperty("hwnd", out var hw) && hw.ValueKind == JsonValueKind.Number) Hwnd = hw.GetInt64();
                if (r.TryGetProperty("bag_ago", out var ba) && ba.ValueKind == JsonValueKind.Number && ba.TryGetInt32(out var bai)) BagAgo = bai;
                if (r.TryGetProperty("written", out var wr) && wr.ValueKind == JsonValueKind.String &&
                    DateTime.TryParseExact(wr.GetString(), "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None, out var wt)) Written = wt;
                if (r.TryGetProperty("run", out var run) && run.ValueKind == JsonValueKind.Object)
                {
                    Run = run.Clone();
                    HasRun = true;
                    if (run.TryGetProperty("state", out var st) && st.ValueKind == JsonValueKind.String) RunState = st.GetString() ?? "";
                }
                Stuff = Things(r, "stuff");
                Items = Things(r, "items");
            }
            catch (Exception) { }
        }

        static List<BagThing> Things(JsonElement r, string key)
        {
            var res = new List<BagThing>();
            if (!r.TryGetProperty(key, out var arr) || arr.ValueKind != JsonValueKind.Array) return res;
            foreach (var e in arr.EnumerateArray())
            {
                var t = new BagThing();
                if (e.TryGetProperty("oid", out var v) && v.TryGetInt32(out var i)) t.Oid = i;
                if (e.TryGetProperty("id", out v) && v.TryGetInt32(out i)) t.Id = i;
                if (e.TryGetProperty("n", out v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out i)) t.N = i;
                if (e.TryGetProperty("ench", out v) && v.TryGetInt32(out i)) t.Ench = i;
                if (e.TryGetProperty("on", out v) && v.ValueKind == JsonValueKind.Number) t.Worn = v.GetInt32() != 0;
                if (e.TryGetProperty("name", out v) && v.ValueKind == JsonValueKind.String) t.Name = v.GetString() ?? "";
                if (e.TryGetProperty("grade", out v) && v.ValueKind == JsonValueKind.String) t.Grade = v.GetString();
                if (e.TryGetProperty("type", out v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out i)) t.Type = i;
                res.Add(t);
            }
            return res;
        }

        public int RunInt(string k) => HasRun && Run.TryGetProperty(k, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out var n) ? n : 0;

        public static bool IsScroll(string n) => Regex.IsMatch(n, "scroll", RegexOptions.IgnoreCase) && Regex.IsMatch(n, "enchant", RegexOptions.IgnoreCase);
        /// <summary>An enchant stone («Lucky Enchant Stone: Armor (A-grade)»...): not a Gemstone / Soulstone / Life Stone.</summary>
        public static bool IsStone(string n) => Regex.IsMatch(n, @"enchant\s+stone|stone[^a-z]{0,3}enchant|lucky|support|protect|камен\w*\s+заточ|камн\w*\s+заточ", RegexOptions.IgnoreCase) &&
                                                !Regex.IsMatch(n, "scroll|soul|life|spirit|gem|ore", RegexOptions.IgnoreCase);

        /// <summary>The character of a command: the one whose game window was in front at the key press; else the only
        /// bot on; else the bot written last.</summary>
        public static CharCtx? Pick(long foreground, out string why)
        {
            why = "";
            var all = All();
            if (all.Count == 0)
            {
                why = "нет ни одного персонажа: запусти Enchanter\\enchant.txt в боте";
                return null;
            }
            var c = all.FirstOrDefault(x => x.Live && x.Hwnd != 0 && x.Hwnd == foreground);
            if (c != null) return c;
            var live = all.Where(x => x.Live).ToList();
            if (live.Count == 1) return live[0];
            if (live.Count > 1)
            {
                why = "ботов несколько: держи клавишу в окне нужного персонажа";
                return null;
            }
            return all.OrderByDescending(x => { try { return File.GetLastWriteTimeUtc(x.StatePath); } catch (Exception) { return DateTime.MinValue; } }).First();
        }
    }

    /// <summary>Short, clear phrases at once (no model): «старт», «стоп», «до плюс шести», «свиток броня А»,
    /// «камни выкл», «пауза 300»... null: not for the rules (long, with conditions, a «не», unknown) - the model's.</summary>
    static class FastParse
    {
        static readonly Dictionary<string, int> NumWords = new Dictionary<string, int>
        {
            ["ноль"] = 0, ["нуля"] = 0, ["один"] = 1, ["одного"] = 1, ["одна"] = 1, ["первый"] = 1, ["первого"] = 1, ["раз"] = 1,
            ["два"] = 2, ["двух"] = 2, ["две"] = 2, ["второй"] = 2, ["второго"] = 2, ["три"] = 3, ["трех"] = 3, ["третий"] = 3, ["третьего"] = 3,
            ["четыре"] = 4, ["четырех"] = 4, ["четвертый"] = 4, ["пять"] = 5, ["пяти"] = 5, ["пятый"] = 5, ["шесть"] = 6, ["шести"] = 6, ["шестой"] = 6,
            ["семь"] = 7, ["семи"] = 7, ["восемь"] = 8, ["восьми"] = 8, ["девять"] = 9, ["девяти"] = 9, ["десять"] = 10, ["десяти"] = 10,
            ["одиннадцать"] = 11, ["одиннадцати"] = 11, ["двенадцать"] = 12, ["двенадцати"] = 12, ["тринадцать"] = 13, ["тринадцати"] = 13,
            ["четырнадцать"] = 14, ["четырнадцати"] = 14, ["пятнадцать"] = 15, ["пятнадцати"] = 15, ["шестнадцать"] = 16, ["шестнадцати"] = 16,
            ["двадцать"] = 20, ["двадцати"] = 20, ["тридцать"] = 30, ["сорок"] = 40, ["пятьдесят"] = 50, ["сто"] = 100, ["двести"] = 200,
            ["триста"] = 300, ["пятьсот"] = 500, ["тысяча"] = 1000, ["тысячу"] = 1000,
        };
        static readonly string[] Complex = { "потом", "затем", "после", "если", "когда", "пока", "но", "или", "не", "только", "кроме", "все", "всю", "без" };

        public static string Normalize(string text)
        {
            var t = text.ToLowerInvariant().Replace('ё', 'е');
            if (!Regex.IsMatch(t, @"пауз|задерж|интервал|секунд|сек\b"))
                t = Regex.Replace(t, @"(?<![\d.,])(\d{1,2})\s*[.,]\s*0?(\d{1,2})(?![\d.,])", m =>
                {
                    int a = int.Parse(m.Groups[1].Value, CultureInfo.InvariantCulture), b = int.Parse(m.Groups[2].Value, CultureInfo.InvariantCulture);
                    return a < b && b <= 30 ? " с " + a + " до " + b + " " : m.Value;
                });
            t = Regex.Replace(t, @"[^\p{L}\p{Nd}+\s]", " ");
            t = Regex.Replace(t, @"\s+", " ").Trim();
            var words = t.Split(' ').Select(w => NumWords.TryGetValue(w, out var n) ? n.ToString(CultureInfo.InvariantCulture) : w).ToList();
            // «двадцать пять» -> 25, «пол секунды» handled by the delay rule
            for (int i = 0; i + 1 < words.Count; i++)
                if (int.TryParse(words[i], out var a) && int.TryParse(words[i + 1], out var b) && a % 10 == 0 && a >= 20 && b < 10)
                {
                    words[i] = (a + b).ToString(CultureInfo.InvariantCulture);
                    words.RemoveAt(i + 1);
                }
            t = string.Join(" ", words);
            t = Regex.Replace(t, @"\bплюс\s*(?=\d)", "+");
            return t.Replace("+ ", "+");
        }

        public static List<VAct>? Parse(string text)
        {
            var t = " " + Normalize(text) + " ";
            var words = t.Trim().Split(' ');
            if (words.Length == 0 || t.Trim().Length == 0) return null;
            if (Regex.IsMatch(t, @"^ (да|ага|подтверждаю|давай|конечно|ок|окей|точно) $")) return new List<VAct> { new VAct { Do = "yes" } };
            if (Regex.IsMatch(t, @"^ (нет|отмена|не надо|не нужно|отбой) $")) return new List<VAct> { new VAct { Do = "no" } };
            bool stopRule = t.Contains("слом") || Regex.IsMatch(t, " [0-9]+ (вещ|штук|шт)");   // «стоп после 3 вещей»: «после» is no condition here
            if (words.Length > 7 || words.Any(w => Complex.Contains(w) && !(stopRule && w == "после"))) return null;

            if (words.Length <= 4 && Regex.IsMatch(t, @" (открой\w*|покажи|перейди|вкладк\w*|разверни) "))
            {
                string tab = Regex.IsMatch(t, @"настройк") ? "opts" : Regex.IsMatch(t, @"истори| лог") ? "log"
                    : Regex.IsMatch(t, @"диапазон") ? "jobs" : Regex.IsMatch(t, @"панел|окн|энчантер|заточк") ? "panel" : "";
                if (tab.Length > 0) return new List<VAct> { new VAct { Do = "ui", Tab = tab } };
            }
            if (words.Length <= 3 && Regex.IsMatch(t, @" (новый|создай|добавь|сделай) ") && Regex.IsMatch(t, @" диапазон "))
                return new List<VAct> { new VAct { Do = "new_range" } };
            var del = Regex.Match(t, @"^ (удали|убери) (диапазон (\d+)|(\d+) диапазон) $");
            if (del.Success) return new List<VAct> { new VAct { Do = "del_range", Job = int.Parse(del.Groups[3].Success && del.Groups[3].Value.Length > 0 ? del.Groups[3].Value : del.Groups[4].Value) } };

            var acts = new List<VAct>();
            int job = 0;
            var mj = Regex.Match(t, @" (диапазон\w*|ренж) (\d+) ");
            if (mj.Success) job = int.Parse(mj.Groups[2].Value);
            var mj2 = Regex.Match(t, @" (\d+) (диапазон\w*|ренж) ");     // «второй диапазон»
            if (!mj.Success && mj2.Success) job = int.Parse(mj2.Groups[1].Value);

            if (Regex.IsMatch(t, @"слом"))                    // a range's stop at a break
            {
                if (Regex.IsMatch(t, @" (до|на|при|после) (1 )?слом|(стоп\w*|останов\w*) (на|при|после) (1 )?слом"))
                    return new List<VAct> { new VAct { Do = "break_stop", Job = job, On = true } };
                return null;
            }
            var mDone = Regex.Match(t, @" (\d+) (вещ\w*|штук\w*|шт) ");
            if (mDone.Success && Regex.IsMatch(t, @" (стоп\w*|после|до|хватит|останов\w*|только) "))
            {
                acts.Add(new VAct { Do = "done_max", Job = job, N = int.Parse(mDone.Groups[1].Value, CultureInfo.InvariantCulture) });
                t = t.Replace(mDone.Value, " ");
                if (Regex.IsMatch(t, @"^ (стоп\w*|после|до|хватит|останов\w*|только|у|цели|цель|\s)* $")) return acts;
            }
            if (Regex.IsMatch(t, @" (стоп|останови\w*|хватит|прекрати\w*|отмени\w*|стой) "))
            {
                acts.Add(new VAct { Do = "stop" });
                return Only(acts, t, @"стоп|останови\w*|хватит|прекрати\w*|отмени\w*|стой|заточку|заточка|бот");
            }
            if (Regex.IsMatch(t, @" (статус|сколько|прогресс|отчет|как дела|что там|как там) ")) return new List<VAct> { new VAct { Do = "status" } };
            if (Regex.IsMatch(t, @"кристал")) return new List<VAct> { new VAct { Do = "cryst_now" } };

            var mFrom = Regex.Match(t, @" (с|от) \+?(\d+) ");
            var mTo = Regex.Match(t, @" (до|на) \+?(\d+) ");
            if (mFrom.Success || mTo.Success)
                acts.Add(new VAct { Do = "range", Job = job, From = mFrom.Success ? int.Parse(mFrom.Groups[2].Value) : -1, To = mTo.Success ? int.Parse(mTo.Groups[2].Value) : -1 });

            if (Regex.IsMatch(t, @" (свит\w*|скрол\w*|scroll|энчант|enchant) "))
            {
                var q = new List<string>();
                if (Regex.IsMatch(t, @"брон|армор|armor|доспе|бижу")) q.Add("armor");
                if (Regex.IsMatch(t, @"оруж|пух|вепон|weapon|меч|лук")) q.Add("weapon");
                if (Regex.IsMatch(t, @"благ|блес|blessed")) q.Add("blessed");
                var g = GradeIn(t);
                if (g != null) q.Add("grade:" + g);
                if (q.Count == 0) return null;
                acts.Add(new VAct { Do = "scroll", Job = job, Query = string.Join(" ", q) });
            }
            if (Regex.IsMatch(t, @" (камни|камней|камнями|камень|камня) "))
            {
                if (Regex.IsMatch(t, @" (вкл\w*|включи\w*|с|да) ")) acts.Add(new VAct { Do = "stones", Job = job, On = true });
                else if (Regex.IsMatch(t, @" (выкл\w*|отключи\w*|без|убери|нет) ")) acts.Add(new VAct { Do = "stones", Job = job, On = false });
                else return null;
            }
            var md = Regex.Match(t, @" (пауза|паузу|задержка|задержку|интервал) (\d+|пол) ?(секунд\w*|сек|с|миллисекунд\w*|мс)? ");
            if (md.Success)
            {
                int ms;
                if (md.Groups[2].Value == "пол") ms = 500;
                else
                {
                    var n = int.Parse(md.Groups[2].Value);
                    var u = md.Groups[3].Value;
                    ms = u.StartsWith("милли") || u == "мс" ? n : u.Length > 0 || n <= 10 ? n * 1000 : n;
                }
                acts.Add(new VAct { Do = Regex.IsMatch(t, @"нов|полож|клад") ? "put" : "delay", Ms = ms });
            }
            var mon = Regex.Match(t, @" (включи|выключи) (диапазон|ренж) (\d+) ");
            if (mon.Success) acts.Add(new VAct { Do = "job_on", Job = int.Parse(mon.Groups[3].Value), On = mon.Groups[1].Value == "включи" });

            bool start = LlmPrompt.SaysStart(t);           // only an explicit «старт» (the user: «заточи до N» only sets the levels)
            if (start) acts.Add(new VAct { Do = "start" });
            if (acts.Count == 0) return null;
            // a word the rules do not know (an item's name, a condition): the model's - it may mean more than the rules saw
            foreach (var w in words)
                if (!Known.IsMatch(w)) return null;
            return acts;
        }

        static readonly Regex Known = new Regex(@"^(\+?\d+|с|со|от|до|на|по|плюс|уровень|уровня|уровней|диапазон\w*|ренж|свит\w*|скрол\w*|scroll|энчант|enchant|" +
            @"брон\w*|армор\w*|armor|доспе\w*|бижу\w*|оруж\w*|пух\w*|вепон\w*|weapon|благ\w*|блес\w*|blessed|грейд\w*|грэйд\w*|grade|[а-яa-z]{1,2}грейд|" +
            @"а|a|эй|б|b|би|c|си|ц|цэ|д|d|ди|s|эс|камн\w*|камен\w*|вкл\w*|включи\w*|выкл\w*|отключи\w*|убери|нет|да|пауза|паузу|задержк\w*|интервал|пол|" +
            @"секунд\w*|сек|миллисекунд\w*|мс|между|заточками|новой|вещи|полож\w*|клад\w*|старт|начни|начинай|начать|запусти\w*|поехали|погнали|го|вперед|" +
            @"точи|заточи\w*|затачивай|доточи\w*|поставь|ставь|выбери|возьми|сделай|давай|пожалуйста|плиз|ну|ок|и|в|бот|заточку|заточка|это|этот|" +
            @"вещ\w*|штук\w*|шт|у|цели|цель|после|только)$");

        /// <summary>The grade said: «C-грейд», «цгрейд», «си», «бэ»... (whisper writes C as «Ц»); «с» alone is a word, not C.</summary>
        public static string? GradeIn(string t)
        {
            var m = Regex.Match(t, @" ([абсцдabcds]|эй|би|бэ|си|цэ|ди|дэ|эс) ?(грейд\w*|грэйд\w*|grade) ");
            if (!m.Success) m = Regex.Match(t, @" ([абсцдabcds])(грейд\w*|грэйд\w*|grade) ");
            if (!m.Success) m = Regex.Match(t, @" (а|a|эй|б|b|би|бэ|си|ц|цэ|c|д|d|ди|дэ|s|эс) ");
            return m.Success ? GradeOf(m.Groups[1].Value) : null;
        }

        static string GradeOf(string w) => w switch
        {
            "а" or "a" or "эй" => "A", "б" or "b" or "би" or "бэ" => "B", "с" or "c" or "си" or "ц" or "цэ" => "C",
            "д" or "d" or "ди" or "дэ" => "D", _ => "S",
        };

        /// <summary>The words left after the known ones: none -> the actions; some -> null (the model decides).</summary>
        static List<VAct>? Only(List<VAct> acts, string t, string known)
        {
            var rest = Regex.Replace(t, @" (" + known + ") ", " ");
            rest = Regex.Replace(rest, @" (" + known + ") ", " ").Trim();
            return rest.Length == 0 ? acts : null;
        }
    }

    /// <summary>The model's part: the rules, the answer's JSON shape, the state of the character in words.</summary>
    static class LlmPrompt
    {
        public const string System = @"Ты переводишь голосовую команду игрока (по-русски, распознанную из речи — возможны ошибки распознавания) в действия бота-заточника для Lineage 2.
Отвечай только JSON по схеме: {""actions"": [...], ""say"": ""короткий ответ по-русски""}.

Действия (поле do):
- start — начать заточку. ТОЛЬКО если явно просят начать: «старт», «начни», «начинай», «запусти», «поехали», «погнали», «го». «Заточи», «доточи», «точить до N» — это уровни (range), НЕ старт.
- stop — остановить заточку. ТОЛЬКО если явно просят остановить: «стоп», «останови», «хватит», «прекрати».
- cryst_now — кристаллизовать сейчас (бот спросит подтверждение).
- range — уровни диапазона: from (с какого +), to (до какого +), job (номер диапазона, 0 = текущий).
- scroll — выбрать свиток: id из списка «Свитки в сумке». Только из этого списка.
- stones — камни on=true/false.
- cryst_mode — что делать после заточки: mode = none (ничего), done (кристаллизовать дошедшие до цели), left (не дошедшие), all (все вещи диапазона).
- delay — пауза между заточками, ms (в миллисекундах).
- put — пауза после того как новая вещь положена в окно, ms.
- done_max — диапазон job заканчивается, когда n его вещей дойдут до его «до» (0 = точить все). Это настройка диапазона.
- break_stop — диапазон job заканчивается на первой сломанной вещи: on=true/false («до первого слома»).
- job_on — включить/выключить диапазон job: on=true/false.
- status — рассказать, как идёт заточка (в say).
- new_range — создать новый диапазон: items (id вещей из «Вещи в сумке»), from, to (если не сказали — 0 и 3), id (свиток, если назвали).
- add_items — добавить вещи items в диапазон job. remove_items — убрать вещи items из диапазона job (items пустой — убрать все).
- del_range — удалить диапазон job (бот переспросит).
- ui — показать в окне панели: tab = jobs (диапазоны), log (история), opts (настройки), panel (просто открыть окно).
- char — выбрать в панели персонажа: name = ник из списка «Персонажи» или ""next"" (другой / следующий).

Правила:
- «плюс шесть», «+6», «на шесть», «до шести» — это уровень 6. «ноль-шесть», «0.6», «0,06» — с 0 до 6.
- Грейды: «а»/«эй» = A, «б»/«би»/«бэ» = B, «с»/«си»/«ц»/«цэ» = C (распознавание пишет C как «Ц»), «д»/«ди» = D, «эс» = S. «броня»/«бижа» = Armor, «оружие»/«пуха» = Weapon, «благословенный»/«блесс» = Blessed.
- Вещи в сумке названы по-английски: кольцо = Ring, серьга = Earring, ожерелье = Necklace, бижа = кольца+серьги+ожерелья, шлем = Helmet, перчатки = Gloves, сапоги = Boots, щит = Shield, сет/броня = Armor/Leather/Robe/Plate. Речь распознаётся с ошибками: ищи похожее по звучанию («ринг» = Ring, «найтмар» = Nightmare, «маджестик» = Majestic, «таллум» = Tallum). id бери только из списка.
- «профиль»/«персонаж»/«перс» — это char. «открой»/«покажи» вкладку — это ui.
- Названа конкретная вещь — бери только её: самую похожую из «Похоже по звучанию на сказанное» (у неё самый большой %). Названа группа («кольца», «бижа», «сет таллума») — все подходящие.
- Свиток к вещам бот подбирает сам (по грейду и броня/оружие). Действие scroll — только если про свиток сказали явно. «не Б, а С», «си грейд» про свиток — это scroll со свитком нужного грейда.
- «убери/удали вещи из диапазона» — это remove_items (диапазон остаётся). del_range — только когда просят удалить сам диапазон.
- Если команда непонятна или просит то, чего нет в списке, — actions пустой, а в say коротко скажи, что не так.
- Ничего не придумывай сверх сказанного. Не запускай заточку, если не просили.
- say — 2-6 слов: что сделано.

Примеры:
«заточи до шести и потом кристаллизуй дошедшие» -> {""actions"":[{""do"":""range"",""to"":6},{""do"":""cryst_mode"",""mode"":""done""}],""say"":""До +6, потом кристалл""}
«до шести и поехали» -> {""actions"":[{""do"":""range"",""to"":6},{""do"":""start""}],""say"":""До +6, старт""}
«поставь свиток на броню а и погнали» -> {""actions"":[{""do"":""scroll"",""id"":<id свитка Armor A из списка>},{""do"":""start""}],""say"":""Свиток брони A, старт""}
«сделай паузу полсекунды между заточками» -> {""actions"":[{""do"":""delay"",""ms"":500}],""say"":""Пауза 0.5 с""}
«второй диапазон с трёх до семи» -> {""actions"":[{""do"":""range"",""job"":2,""from"":3,""to"":7}],""say"":""Диапазон 2: +3 → +7""}
«как там дела» -> {""actions"":[{""do"":""status""}],""say"":""<состояние>""}
«создай новый диапазон с кольцами до плюс четырёх» -> {""actions"":[{""do"":""new_range"",""items"":[<id колец из списка>],""to"":4}],""say"":""Новый диапазон: кольца до +4""}
«добавь в первый диапазон серьги» -> {""actions"":[{""do"":""add_items"",""job"":1,""items"":[<id серёг>]}],""say"":""Серьги добавлены""}
«убери все вещи из диапазона» -> {""actions"":[{""do"":""remove_items"",""items"":[]}],""say"":""Вещи убраны""}
«удали второй диапазон» -> {""actions"":[{""do"":""del_range"",""job"":2}],""say"":""Удалить диапазон 2?""}
«открой историю» -> {""actions"":[{""do"":""ui"",""tab"":""log""}],""say"":""История""}
«точи до первого слома» -> {""actions"":[{""do"":""break_stop"",""on"":true}],""say"":""Стоп на первом сломе""}
«во втором диапазоне стоп после трёх вещей» -> {""actions"":[{""do"":""done_max"",""job"":2,""n"":3}],""say"":""Диапазон 2: стоп после 3""}
«выбери другого персонажа» -> {""actions"":[{""do"":""char"",""name"":""next""}],""say"":""Другой персонаж""}";

        public static readonly JsonNode Schema = JsonNode.Parse(@"{
  ""type"": ""object"",
  ""properties"": {
    ""actions"": { ""type"": ""array"", ""items"": { ""type"": ""object"", ""properties"": {
      ""do"": { ""type"": ""string"", ""enum"": [""start"",""stop"",""cryst_now"",""range"",""scroll"",""stones"",""cryst_mode"",""delay"",""put"",""done_max"",""job_on"",""status"",""new_range"",""add_items"",""remove_items"",""del_range"",""ui"",""char"",""break_stop""] },
      ""job"": { ""type"": ""integer"" }, ""from"": { ""type"": ""integer"" }, ""to"": { ""type"": ""integer"" }, ""id"": { ""type"": ""integer"" },
      ""on"": { ""type"": ""boolean"" }, ""mode"": { ""type"": ""string"", ""enum"": [""none"",""done"",""left"",""all""] },
      ""ms"": { ""type"": ""integer"" }, ""n"": { ""type"": ""integer"" },
      ""items"": { ""type"": ""array"", ""items"": { ""type"": ""integer"" } },
      ""tab"": { ""type"": ""string"", ""enum"": [""jobs"",""log"",""opts"",""panel""] },
      ""name"": { ""type"": ""string"" } },
      ""required"": [""do""] } },
    ""say"": { ""type"": ""string"" }
  },
  ""required"": [""actions"", ""say""]
}")!;

        static readonly Dictionary<string, string> CrystWords = new Dictionary<string, string>
        { ["none"] = "ничего", ["done"] = "кристаллизовать дошедшие", ["left"] = "кристаллизовать не дошедшие", ["all"] = "кристаллизовать все" };

        static readonly Dictionary<char, string> Tr = new Dictionary<char, string>
        {
            ['а'] = "a", ['б'] = "b", ['в'] = "v", ['г'] = "g", ['д'] = "d", ['е'] = "e", ['ж'] = "zh", ['з'] = "z", ['и'] = "i", ['й'] = "y", ['к'] = "k",
            ['л'] = "l", ['м'] = "m", ['н'] = "n", ['о'] = "o", ['п'] = "p", ['р'] = "r", ['с'] = "s", ['т'] = "t", ['у'] = "u", ['ф'] = "f", ['х'] = "h",
            ['ц'] = "c", ['ч'] = "ch", ['ш'] = "sh", ['щ'] = "sch", ['ъ'] = "", ['ы'] = "y", ['ь'] = "", ['э'] = "e", ['ю'] = "yu", ['я'] = "ya",
        };

        /// <summary>Russian letters as Latin ones (whisper writes «ринг оф сил» for «Ring of Seal»).</summary>
        public static string Lat(string s)
        {
            var sb = new StringBuilder();
            foreach (var ch in s.ToLowerInvariant().Replace('ё', 'е'))
                sb.Append(Tr.TryGetValue(ch, out var v) ? v : char.IsLetterOrDigit(ch) ? ch.ToString() : " ");
            return sb.ToString();
        }

        static int Lev(string a, string b)
        {
            var d = new int[b.Length + 1];
            for (int j = 0; j <= b.Length; j++) d[j] = j;
            for (int i = 1; i <= a.Length; i++)
            {
                int prev = d[0];
                d[0] = i;
                for (int j = 1; j <= b.Length; j++)
                {
                    int tmp = d[j];
                    d[j] = Math.Min(Math.Min(d[j] + 1, d[j - 1] + 1), prev + (a[i - 1] == b[j - 1] ? 0 : 1));
                    prev = tmp;
                }
            }
            return d[b.Length];
        }

        /// <summary>The bag's gear (not worn) whose name sounds like the words said: the best first (score 0..1).</summary>
        public static List<(BagThing T, double S)> SoundsLike(CharCtx c, string text)
        {
            var said = Lat(text).Split(' ', StringSplitOptions.RemoveEmptyEntries).Where(w => w.Length >= 2).ToList();
            var res = new List<(BagThing, double)>();
            if (said.Count == 0) return res;
            foreach (var g in c.Items.Where(x => !x.Worn).GroupBy(x => x.Id))
            {
                var it = g.First();
                var toks = Lat(it.Name).Split(' ', StringSplitOptions.RemoveEmptyEntries).Where(w => w.Length >= 2).ToList();
                if (toks.Count == 0) continue;
                double sum = 0;
                foreach (var w in toks) sum += said.Max(s => 1.0 - (double)Lev(w, s) / Math.Max(w.Length, s.Length));
                res.Add((it, sum / toks.Count));
            }
            return res.Where(x => x.Item2 >= 0.45).OrderByDescending(x => x.Item2).Take(6).ToList();
        }

        public static string State(CharCtx c, string text = "")
        {
            var sb = new StringBuilder();
            sb.Append("Персонаж: ").Append(c.Name).Append(". Бот ").Append(c.Live ? "на связи" : "НЕ на связи").Append(". Заточка ")
              .Append(c.Running ? "идёт" : "стоит").Append(".\n");
            if (c.Running || c.RunInt("tries") > 0)
                sb.Append("Последний запуск: попыток ").Append(c.RunInt("tries")).Append(", успешно ").Append(c.RunInt("ok"))
                  .Append(", сломано ").Append(c.RunInt("broke")).Append(", свитков ").Append(c.RunInt("scrolls")).Append(".\n");
            int jn = c.Doc.JobCount;
            sb.Append("Диапазоны:\n");
            if (jn == 0) sb.Append("  (нет ни одного)\n");
            for (int j = 0; j < jn; j++)
            {
                int sc = c.Doc.GetInt(j, "scroll", 0);
                var scn = c.Doc.Get(j, "scroll_name") ?? "";
                var have = c.Stuff.FirstOrDefault(x => x.Id == sc);
                sb.Append("  ").Append(j + 1).Append(") «").Append(c.Doc.Get(j, "name") ?? "").Append("» ").Append(c.Doc.Get(j, "on") == "0" ? "выкл" : "вкл")
                  .Append(", с +").Append(c.Doc.GetInt(j, "from", 0)).Append(" до +").Append(c.Doc.GetInt(j, "to", 3))
                  .Append(", свиток: ").Append(sc > 0 ? scn + " [" + sc + "]" + (have != null ? " ×" + have.N : " (нет в сумке)") : "не выбран")
                  .Append(", камни: ").Append(c.Doc.Get(j, "stone_on") == "1" ? "вкл" : "выкл")
                  .Append(", потом: ").Append(CrystWords.TryGetValue(c.Doc.Get(j, "cryst") ?? "none", out var cw) ? cw : "ничего");
                var kinds = c.Doc.GetAll(j, "kind").Select(k => { var p = k.Split('|'); return p.Length > 1 ? p[1] : k; }).ToList();
                if (kinds.Count > 0) sb.Append(", вещи: ").Append(string.Join(", ", kinds.Take(8))).Append(kinds.Count > 8 ? "…" : "");
                sb.Append('\n');
            }
            var scrolls = c.Stuff.Where(x => CharCtx.IsScroll(x.Name)).ToList();
            sb.Append("Свитки в сумке: ").Append(scrolls.Count == 0 ? "нет" : string.Join("; ", scrolls.Select(x => "[" + x.Id + "] " + x.Name + " ×" + x.N))).Append('\n');
            var gear = c.Items.Where(x => !x.Worn).GroupBy(x => x.Id).Take(60).ToList();
            sb.Append("Вещи в сумке (не надетые): ").Append(gear.Count == 0 ? "нет" : string.Join("; ", gear.Select(g =>
                "[" + g.Key + "] " + g.First().Name + " ×" + g.Count() + " (" + string.Join(",", g.Select(x => "+" + x.Ench).Distinct().OrderBy(x => x)) + ")"))).Append('\n');
            var like = SoundsLike(c, text);
            if (like.Count > 0)
                sb.Append("Похоже по звучанию на сказанное: ").Append(string.Join(", ", like.Select(x => "[" + x.T.Id + "] " + x.T.Name + " (" + Math.Round(x.S * 100) + "%)"))).Append('\n');
            var chars = CharCtx.All().Select(x => x.Name + (x.Live ? "" : " (бот не на связи)"));
            sb.Append("Персонажи: ").Append(string.Join(", ", chars)).Append('\n');
            sb.Append("Пауза между заточками ").Append(c.Doc.GetInt(-1, "delay_ms", 200)).Append(" мс, после новой вещи ").Append(c.Doc.GetInt(-1, "put_ms", 2000)).Append(" мс.\n");
            return sb.ToString();
        }

        static readonly Regex StartWords = new Regex(@" (старт\w*|начни|начинай|начать|начнем|начинаем|запусти\w*|поехали|погнали|го|вперед) ");
        static readonly Regex StopWords = new Regex(@" (стоп\w*|останови\w*|остановись|хватит|прекрати\w*|стой|отмени\w*) ");

        /// <summary>Normalized words (FastParse.Normalize, spaces around) ask to start the run.</summary>
        public static bool SaysStart(string t) => StartWords.IsMatch(t);

        /// <summary>The user: the run starts / stops only when asked in so many words. The model's start / stop without
        /// such a word: dropped (true: something was dropped).</summary>
        public static bool ExplicitOnly(string text, List<VAct> acts)
        {
            var t = " " + FastParse.Normalize(text) + " ";
            int n = acts.RemoveAll(a => (a.Do == "start" && !StartWords.IsMatch(t)) || (a.Do == "stop" && !StopWords.IsMatch(t)));
            return n > 0;
        }

        /// <summary>The levels said («до четырёх», «с трёх») but missed by the model: taken from the words.</summary>
        public static void NumberFix(string text, List<VAct> acts)
        {
            var t = " " + FastParse.Normalize(text) + " ";
            var mTo = Regex.Match(t, @" (до|на) \+?(\d+) ");
            var mFrom = Regex.Match(t, @" (с|от|со) \+?(\d+) ");
            var rng = acts.Where(a => a.Do is "new_range" or "range").ToList();
            foreach (var a in rng)
            {
                if (a.To < 0 && mTo.Success) a.To = int.Parse(mTo.Groups[2].Value, CultureInfo.InvariantCulture);
                if (a.From < 0 && mFrom.Success) a.From = int.Parse(mFrom.Groups[2].Value, CultureInfo.InvariantCulture);
            }
            if (rng.Count == 0 && (mTo.Success || mFrom.Success) && acts.Any(a => a.Do == "add_items"))
                acts.Add(new VAct { Do = "range", To = mTo.Success ? int.Parse(mTo.Groups[2].Value, CultureInfo.InvariantCulture) : -1,
                                    From = mFrom.Success ? int.Parse(mFrom.Groups[2].Value, CultureInfo.InvariantCulture) : -1 });
        }

        public static List<VAct> ParseAnswer(string json, out string say)
        {
            say = "";
            var res = new List<VAct>();
            var j = JsonNode.Parse(json);
            say = j?["say"]?.GetValue<string>() ?? "";
            if (j?["actions"] is not JsonArray arr) return res;
            foreach (var a in arr)
            {
                if (a is not JsonObject o) continue;
                var v = new VAct { Do = o["do"]?.GetValue<string>() ?? "" };
                if (o["job"] is JsonNode jb) v.Job = jb.GetValue<int>();
                if (o["from"] is JsonNode f) v.From = f.GetValue<int>();
                if (o["to"] is JsonNode t) v.To = t.GetValue<int>();
                if (o["id"] is JsonNode id) v.Id = id.GetValue<int>();
                if (o["on"] is JsonNode on) v.On = on.GetValue<bool>();
                if (o["mode"] is JsonNode m) v.Mode = m.GetValue<string>();
                if (o["ms"] is JsonNode ms) v.Ms = ms.GetValue<int>();
                if (o["n"] is JsonNode n) v.N = n.GetValue<int>();
                if (o["items"] is JsonArray it) foreach (var x in it) if (x != null) v.Items.Add(x.GetValue<int>());
                if (o["tab"] is JsonNode tb) v.Tab = tb.GetValue<string>();
                if (o["name"] is JsonNode nm) v.Name = nm.GetValue<string>();
                if (v.Do.Length > 0) res.Add(v);
            }
            return res;
        }
    }

    /// <summary>The actions done on a character's settings (as the page does them); one file write at the end.</summary>
    static class VExec
    {
        public sealed class Result
        {
            public readonly List<string> Done = new List<string>();
            public readonly List<string> Errors = new List<string>();
            public string Ask = "";                          // a question: the Pending actions wait for «да»
            public readonly List<VAct> Pending = new List<VAct>();
            public string UiTab = "", UiChar = "";           // for the page: a tab / a character to show
            public bool Ok => Errors.Count == 0 && (Done.Count > 0 || Ask.Length > 0 || UiTab.Length > 0 || UiChar.Length > 0);
        }

        static readonly Dictionary<string, string> CrystSay = new Dictionary<string, string>
        { ["none"] = "потом ничего", ["done"] = "потом кристалл дошедших", ["left"] = "потом кристалл недошедших", ["all"] = "потом кристалл всех" };
        static readonly Dictionary<string, string> TabSay = new Dictionary<string, string>
        { ["jobs"] = "диапазоны", ["log"] = "история", ["opts"] = "настройки", ["panel"] = "панель" };

        static string NowId() => DateTimeOffset.UtcNow.ToUnixTimeMilliseconds().ToString(CultureInfo.InvariantCulture);
        static string Clean(string s) => s.Replace("|", " ").Replace("\r", " ").Replace("\n", " ").Trim();

        static int JobOf(CharCtx c, int job, Result r)
        {
            int n = c.Doc.JobCount;
            if (n == 0)
            {
                r.Errors.Add("нет диапазонов — скажи «новый диапазон»");
                return -1;
            }
            if (job > 0)
            {
                if (job > n)
                {
                    r.Errors.Add("нет диапазона " + job);
                    return -1;
                }
                return job - 1;
            }
            for (int j = n - 1; j >= 0; j--)            // the active one: the last one turned on (a new one is the last)
                if (c.Doc.Get(j, "on") != "0") return j;
            return n - 1;
        }

        /// <summary>Why it cannot start now ('' = it can), as the page checks it.</summary>
        static string StartProblem(CharCtx c)
        {
            if (!c.Live) return "бот не на связи — запусти enchant.txt";
            if (c.Running) return "заточка уже идёт";
            int n = c.Doc.JobCount;
            if (n == 0) return "нет диапазонов";
            var on = Enumerable.Range(0, n).Where(j => c.Doc.Get(j, "on") != "0").ToList();
            if (on.Count == 0) return "все диапазоны выключены";
            if (!on.Any(j => c.Doc.GetAll(j, "kind").Count + c.Doc.GetAll(j, "item").Count > 0)) return "не выбрано ни одной вещи";
            foreach (var j in on)
            {
                if (c.Doc.GetInt(j, "from", 0) >= c.Doc.GetInt(j, "to", 3)) return "диапазон " + (j + 1) + ": «до» должно быть больше «с»";
                if (c.Doc.GetInt(j, "scroll", 0) <= 0) return "диапазон " + (j + 1) + ": не выбран свиток";
                if (c.Doc.Get(j, "stone_on") == "1" && c.Doc.GetInt(j, "stone", 0) <= 0) return "диапазон " + (j + 1) + ": камни включены, а камень не выбран";
                int sc = c.Doc.GetInt(j, "scroll", 0);
                if (c.Stuff.Count > 0 && !c.Stuff.Any(x => x.Id == sc)) return "диапазон " + (j + 1) + ": свитка нет в сумке";
                var need = Need(c, j);
                if (need.N > 0 && !need.Mixed && !Fits(c.Doc.Get(j, "scroll_name") ?? "", need)) return "диапазон " + (j + 1) + ": свиток не подходит к вещам (нужен " + NeedText(need) + ")";
            }
            return "";
        }

        public static BagThing? FindScroll(CharCtx c, string query) => FindScrolls(c, query).FirstOrDefault();

        public static List<BagThing> FindScrolls(CharCtx c, string query)
        {
            var q = query.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            var list = c.Stuff.Where(x => CharCtx.IsScroll(x.Name)).ToList();
            bool blessed = q.Contains("blessed");
            list = list.Where(x => x.Name.Contains("Blessed", StringComparison.OrdinalIgnoreCase) == blessed).ToList();
            if (q.Contains("armor")) list = list.Where(x => x.Name.Contains("Armor", StringComparison.OrdinalIgnoreCase)).ToList();
            if (q.Contains("weapon")) list = list.Where(x => x.Name.Contains("Weapon", StringComparison.OrdinalIgnoreCase)).ToList();
            var g = q.FirstOrDefault(x => x.StartsWith("grade:"));
            if (g != null)
            {
                var gr = g.Substring(6);
                list = list.Where(x => Regex.IsMatch(x.Name, @"\(" + gr + @"[- ]", RegexOptions.IgnoreCase)).ToList();
            }
            return list.OrderByDescending(x => x.N).ToList();
        }

        // ---------- the scroll fits the items: weapon / armor (jewelry too), the same grade ----------

        /// <summary>A scroll's kind from its name: «Scroll: Enchant Armor (C-grade)» -> armor, C, not blessed. null: not an enchant scroll.</summary>
        public static (bool Weapon, string Grade, bool Blessed)? ScrollInfo(string name)
        {
            var m = Regex.Match(name, @"Enchant\s+(Weapon|Armor)", RegexOptions.IgnoreCase);
            var g = Regex.Match(name, @"\(\s*([A-Z0-9]+)\s*[- ]\s*grade", RegexOptions.IgnoreCase);
            if (!m.Success || !g.Success) return null;
            return (m.Groups[1].Value.Equals("Weapon", StringComparison.OrdinalIgnoreCase), g.Groups[1].Value.ToUpperInvariant(),
                    name.Contains("Blessed", StringComparison.OrdinalIgnoreCase));
        }

        /// <summary>What range j needs: the grade and weapon / armor of its items (null: none / mixed).</summary>
        static (string? Grade, bool? Weapon, bool Mixed, int N) Need(CharCtx c, int j)
        {
            var ids = c.Doc.GetAll(j, "kind").Select(k => int.TryParse(k.Split('|')[0], out var v) ? v : 0)
                .Concat(c.Doc.GetAll(j, "item").Select(k => { var p = k.Split('|'); return p.Length > 1 && int.TryParse(p[1], out var v) ? v : 0; }))
                .Where(x => x > 0).Distinct().ToList();
            var its = ids.Select(id => c.Items.FirstOrDefault(x => x.Id == id)).Where(x => x != null).Select(x => x!).ToList();
            if (its.Count == 0) return (null, null, false, 0);
            var grades = its.Select(x => (x.Grade ?? "").ToUpperInvariant()).Distinct().ToList();
            var weap = its.Select(x => x.Type == 0).Distinct().ToList();
            return (grades.Count == 1 ? grades[0] : null, weap.Count == 1 ? weap[0] : null, grades.Count > 1 || weap.Count > 1, its.Count);
        }

        static bool Fits(string scrollName, (string? Grade, bool? Weapon, bool Mixed, int N) need)
        {
            var s = ScrollInfo(scrollName);
            if (s == null) return true;                                 // not a known kind of scroll: not judged
            if (need.Grade != null && s.Value.Grade != need.Grade) return false;
            if (need.Weapon != null && s.Value.Weapon != need.Weapon) return false;
            return true;
        }

        /// <summary>A stone fits the items: «...: Armor (A-grade)» - armor / weapon and the grade, as a scroll.</summary>
        static bool FitsStone(string name, (string? Grade, bool? Weapon, bool Mixed, int N) need)
        {
            var w = Regex.Match(name, @"\b(Armor|Weapon)\b", RegexOptions.IgnoreCase);
            var g = Regex.Match(name, @"\(\s*([A-Z0-9]+)\s*[- ]\s*grade", RegexOptions.IgnoreCase);
            if (need.Grade != null && g.Success && !g.Groups[1].Value.Equals(need.Grade, StringComparison.OrdinalIgnoreCase)) return false;
            if (need.Weapon != null && w.Success && w.Groups[1].Value.Equals("Weapon", StringComparison.OrdinalIgnoreCase) != need.Weapon) return false;
            return true;
        }

        static string NeedText((string? Grade, bool? Weapon, bool Mixed, int N) need) =>
            (need.Weapon == true ? "оружия " : need.Weapon == false ? "брони " : "") + (need.Grade ?? "");

        /// <summary>The bag's scroll for these items: the plain one with the most, else a blessed one.</summary>
        static BagThing? BestScroll(CharCtx c, (string? Grade, bool? Weapon, bool Mixed, int N) need) =>
            c.Stuff.Where(x => CharCtx.IsScroll(x.Name) && ScrollInfo(x.Name) != null && Fits(x.Name, need))
                   .OrderBy(x => ScrollInfo(x.Name)!.Value.Blessed ? 1 : 0).ThenByDescending(x => x.N).FirstOrDefault();

        /// <summary>Range j's scroll checked against its items: none / not fitting -> the fitting one of the bag (said why).</summary>
        static void FitScroll(CharCtx c, int j, Result r)
        {
            var need = Need(c, j);
            if (need.N == 0) return;
            if (need.Mixed) r.Done.Add("⚠ в диапазоне вещи разных грейдов/типов — один свиток подойдёт не всем");
            int sc = c.Doc.GetInt(j, "scroll", 0);
            var name = c.Doc.Get(j, "scroll_name") ?? "";
            if (sc > 0 && Fits(name, need) && c.Stuff.Any(x => x.Id == sc)) return;
            var best = BestScroll(c, need);
            if (best == null)
            {
                if (sc > 0 && !Fits(name, need)) r.Errors.Add("свиток " + name + " не подходит к вещам (" + NeedText(need) + "), а подходящего в сумке нет");
                else if (sc <= 0) r.Done.Add("⚠ свитка " + NeedText(need) + " в сумке нет");
                return;
            }
            c.Doc.Set(j, "scroll", best.Id.ToString(CultureInfo.InvariantCulture));
            c.Doc.Set(j, "scroll_name", Clean(best.Name));
            r.Done.Add((sc > 0 ? "свиток заменён под вещи: " : "свиток под вещи: ") + best.Name + " ×" + best.N);
        }

        public static string Status(CharCtx c)
        {
            if (!c.Live) return c.Name + ": бот не на связи";
            if (!c.Running)
            {
                var tries = c.RunInt("tries");
                return c.Name + ": стоит" + (tries > 0 ? " (было " + tries + " попыток, " + c.RunInt("ok") + " ок, " + c.RunInt("broke") + " сломано)" : "");
            }
            return c.Name + ": точу — " + c.RunInt("tries") + " попыток, " + c.RunInt("ok") + " ок, " + c.RunInt("broke") + " сломано";
        }

        /// <summary>The kinds (item IDs) of the bag for a range: only the ones there, not worn; their names.</summary>
        static List<(int Id, string Name)> Kinds(CharCtx c, List<int> ids, Result r)
        {
            var res = new List<(int, string)>();
            foreach (var id in ids.Distinct())
            {
                var t = c.Items.FirstOrDefault(x => x.Id == id && !x.Worn) ?? c.Items.FirstOrDefault(x => x.Id == id);
                if (t == null)
                {
                    r.Errors.Add("вещи " + id + " нет в сумке");
                    continue;
                }
                res.Add((id, Clean(t.Name)));
            }
            return res;
        }

        public static Result Apply(CharCtx c, List<VAct> acts, bool confirmed)
        {
            var r = new Result();
            var fixedActs = new List<VAct>();
            foreach (var a in acts)
            {
                var scrollIds = a.Items.Where(id => c.Stuff.Any(x => x.Id == id && CharCtx.IsScroll(x.Name))).ToList();
                if (scrollIds.Count > 0)
                {
                    a.Items.RemoveAll(id => scrollIds.Contains(id));
                    if (a.Do == "new_range" && a.Id <= 0) a.Id = scrollIds[0];
                    else fixedActs.Add(new VAct { Do = "scroll", Job = a.Job, Id = scrollIds[0] });
                }
                if (a.Do == "range" && a.Items.Count > 0)                  // «Ring of Seal до +5»: the items go into that range
                    fixedActs.Add(new VAct { Do = "add_items", Job = a.Job, Items = new List<int>(a.Items) });
                if (a.Do is not ("new_range" or "add_items" or "remove_items")) a.Items.Clear();
                if (a.Do is "range" or "new_range" && a.From >= 0 && a.From == a.To) a.From = -1;   // «с +5 до +5»: a slip
                if (a.Do == "range" && a.From < 0 && a.To < 0) continue;   // nothing to set: dropped
                fixedActs.Add(a);
            }
            // no range yet, but the command sets one up (items, levels, a scroll...): a new range made of all that
            if (c.Doc.JobCount == 0 && !fixedActs.Any(a => a.Do == "new_range") &&
                fixedActs.Any(a => a.Do is "range" or "add_items" or "scroll" or "stones" or "cryst_mode" or "done_max" or "break_stop"))
            {
                var nr = new VAct { Do = "new_range" };
                foreach (var a in fixedActs.Where(a => a.Do is "range" or "add_items").ToList())
                {
                    if (a.From >= 0) nr.From = a.From;
                    if (a.To >= 0) nr.To = a.To;
                    nr.Items.AddRange(a.Items);
                    fixedActs.Remove(a);
                }
                var sca = fixedActs.FirstOrDefault(a => a.Do == "scroll" && a.Id > 0);
                if (sca != null) { nr.Id = sca.Id; fixedActs.Remove(sca); }
                fixedActs.Insert(0, nr);
            }
            acts = fixedActs;
            // stop first, a new range, the settings, then start / crystallize (the order of the words does not matter)
            int Rank(VAct a) => a.Do == "stop" ? 0 : a.Do == "new_range" ? 1 : a.Do == "start" || a.Do == "cryst_now" ? 3 : 2;
            // (a new range is the last one: the range settings after it go to it)
            foreach (var a in acts.OrderBy(Rank))
            {
                switch (a.Do)
                {
                    case "stop":
                        if (!c.Running && c.Doc.Get(-1, "run") != "1") { r.Done.Add("и так стоит"); break; }
                        c.Doc.Set(-1, "run", "0");
                        r.Done.Add("стоп");
                        break;
                    case "status":
                        r.Done.Add(Status(c));
                        break;
                    case "ui":
                        r.UiTab = TabSay.ContainsKey(a.Tab) ? a.Tab : "panel";
                        r.Done.Add("открываю: " + TabSay[r.UiTab]);
                        break;
                    case "char":
                    {
                        var all = CharCtx.All();
                        CharCtx? to = null;
                        if (a.Name.Length == 0 || a.Name.Equals("next", StringComparison.OrdinalIgnoreCase))
                        {
                            var order = all.OrderBy(x => x.Name, StringComparer.OrdinalIgnoreCase).ToList();
                            int i = order.FindIndex(x => x.Tag == c.Tag);
                            if (order.Count > 1) to = order[(i + 1) % order.Count];
                        }
                        else to = all.FirstOrDefault(x => x.Name.Equals(a.Name, StringComparison.OrdinalIgnoreCase) || x.Tag.Equals(a.Name, StringComparison.OrdinalIgnoreCase))
                                  ?? all.FirstOrDefault(x => x.Name.StartsWith(a.Name, StringComparison.OrdinalIgnoreCase));
                        if (to == null) { r.Errors.Add(a.Name.Length > 0 && a.Name != "next" ? "нет персонажа " + a.Name : "другого персонажа нет"); break; }
                        r.UiChar = to.Tag;
                        r.Done.Add("персонаж " + to.Name);
                        break;
                    }
                    case "new_range":
                    {
                        int n = c.Doc.JobCount;
                        int from = a.From >= 0 ? a.From : 0, to = a.To >= 0 ? a.To : 3;
                        if (from < 0 || to > 30 || from >= to) { r.Errors.Add("уровни +" + from + " → +" + to + " не годятся"); break; }
                        var kinds = Kinds(c, a.Items, r);
                        var sc = a.Id > 0 ? c.Stuff.FirstOrDefault(x => x.Id == a.Id) : null;
                        if (a.Id > 0 && sc == null) r.Errors.Add("свитка " + a.Id + " нет в сумке");
                        var lines = new List<string>
                        {
                            "on=1", "name=Диапазон " + (n + 1), "from=" + from, "to=" + to,
                            "scroll=" + (sc?.Id ?? 0), "scroll_name=" + (sc != null ? Clean(sc.Name) : ""),
                            "stone_on=0", "stone=0", "stone_name=", "stone_from=-1", "stone_to=-1", "cryst=none",
                        };
                        lines.AddRange(kinds.Select(k => "kind=" + k.Id + "|" + k.Name));
                        c.Doc.AddJob(lines);
                        r.Done.Add("новый диапазон " + (n + 1) + ": +" + from + " → +" + to + (kinds.Count > 0 ? ", " + string.Join(", ", kinds.Select(k => k.Name)) : ", вещей пока нет") +
                                   (sc != null ? ", свиток " + sc.Name : ""));
                        FitScroll(c, n, r);
                        r.UiTab = "jobs";
                        break;
                    }
                    case "add_items":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        if (a.Items.Count == 0) { r.Errors.Add("не понял, какие вещи"); break; }
                        var have = c.Doc.GetAll(j, "kind").Select(k => k.Split('|')[0]).ToHashSet();
                        var add = Kinds(c, a.Items, r).Where(k => !have.Contains(k.Id.ToString(CultureInfo.InvariantCulture))).ToList();
                        foreach (var k in add) c.Doc.AddLine(j, "kind=" + k.Id + "|" + k.Name);
                        r.Done.Add(add.Count > 0 ? "диапазон " + (j + 1) + ": + " + string.Join(", ", add.Select(k => k.Name)) : "эти вещи уже в диапазоне");
                        FitScroll(c, j, r);
                        break;
                    }
                    case "remove_items":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        int n = 0;
                        if (a.Items.Count == 0) n = c.Doc.RemoveLines(j, "kind", "") + c.Doc.RemoveLines(j, "item", "");
                        else foreach (var id in a.Items) n += c.Doc.RemoveLines(j, "kind", id + "|");
                        r.Done.Add(n > 0 ? "диапазон " + (j + 1) + ": убрано " + n : "таких вещей в диапазоне нет");
                        break;
                    }
                    case "del_range":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        if (c.Running) { r.Errors.Add("сначала останови заточку"); break; }
                        if (!confirmed)
                        {
                            r.Ask = "удалить диапазон " + (j + 1) + "? скажи «да»";
                            r.Pending.Add(new VAct { Do = "del_range", Job = j + 1 });
                            break;
                        }
                        c.Doc.RemoveJob(j);
                        r.Done.Add("диапазон " + (j + 1) + " удалён");
                        r.UiTab = "jobs";
                        break;
                    }
                    case "range":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        int from = a.From >= 0 ? a.From : c.Doc.GetInt(j, "from", 0);
                        int to = a.To >= 0 ? a.To : c.Doc.GetInt(j, "to", 3);
                        if (from < 0 || to > 30 || from >= to)
                        {
                            r.Errors.Add("уровни +" + from + " → +" + to + " не годятся");
                            break;
                        }
                        c.Doc.Set(j, "from", from.ToString(CultureInfo.InvariantCulture));
                        c.Doc.Set(j, "to", to.ToString(CultureInfo.InvariantCulture));
                        r.Done.Add((c.Doc.JobCount > 1 ? "диапазон " + (j + 1) + ": " : "") + "+" + from + " → +" + to);
                        break;
                    }
                    case "scroll":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        var cands = a.Id > 0 ? c.Stuff.Where(x => x.Id == a.Id).ToList() : FindScrolls(c, a.Query);
                        var need = Need(c, j);
                        var s = cands.FirstOrDefault(x => need.N == 0 || Fits(x.Name, need)) ?? cands.FirstOrDefault();
                        string note = "";
                        if (s != null && need.N > 0 && !Fits(s.Name, need))
                        {
                            var best = BestScroll(c, need);
                            if (best == null)
                            {
                                r.Errors.Add("свиток " + s.Name + " не подходит к вещам диапазона (нужен " + NeedText(need) + "), а подходящего в сумке нет");
                                break;
                            }
                            note = " (" + s.Name + " не подходит к вещам " + NeedText(need) + ")";
                            s = best;
                        }
                        if (s == null)
                        {
                            r.Errors.Add("такого свитка нет в сумке");
                            break;
                        }
                        c.Doc.Set(j, "scroll", s.Id.ToString(CultureInfo.InvariantCulture));
                        c.Doc.Set(j, "scroll_name", Clean(s.Name));
                        r.Done.Add("свиток " + s.Name + " ×" + s.N + note);
                        break;
                    }
                    case "stones":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        bool on = a.On ?? true;
                        c.Doc.Set(j, "stone_on", on ? "1" : "0");
                        string stNote = "";
                        if (on)
                        {
                            var need = Need(c, j);
                            int cur = c.Doc.GetInt(j, "stone", 0);
                            var curName = c.Doc.Get(j, "stone_name") ?? "";
                            bool curOk = cur > 0 && c.Stuff.Any(x => x.Id == cur) && (need.N == 0 || FitsStone(curName, need));
                            if (!curOk)
                            {
                                var st = c.Stuff.Where(x => CharCtx.IsStone(x.Name) && (need.N == 0 || FitsStone(x.Name, need))).OrderByDescending(x => x.N).FirstOrDefault();
                                if (st != null)
                                {
                                    c.Doc.Set(j, "stone", st.Id.ToString(CultureInfo.InvariantCulture));
                                    c.Doc.Set(j, "stone_name", Clean(st.Name));
                                    stNote = ": " + st.Name + " ×" + st.N;
                                }
                                else stNote = " (⚠ камня " + NeedText(need) + " в сумке нет)";
                            }
                        }
                        r.Done.Add(on ? "камни вкл" + stNote : "камни выкл");
                        break;
                    }
                    case "cryst_mode":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        var m = CrystSay.ContainsKey(a.Mode) ? a.Mode : "none";
                        c.Doc.Set(j, "cryst", m);
                        r.Done.Add(CrystSay[m]);
                        break;
                    }
                    case "delay":
                    case "put":
                    {
                        if (a.Ms < 0 || a.Ms > 60000)
                        {
                            r.Errors.Add("пауза не годится");
                            break;
                        }
                        c.Doc.Set(-1, a.Do == "delay" ? "delay_ms" : "put_ms", a.Ms.ToString(CultureInfo.InvariantCulture));
                        r.Done.Add((a.Do == "delay" ? "пауза " : "после новой вещи ") + (a.Ms / 1000.0).ToString("0.##", CultureInfo.InvariantCulture) + " с");
                        break;
                    }
                    case "done_max":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        int n = Math.Max(0, a.N);
                        c.Doc.Set(j, "done_max", n.ToString(CultureInfo.InvariantCulture));
                        r.Done.Add("диапазон " + (j + 1) + ": " + (n > 0 ? "стоп после " + n + " вещей у цели" : "точить все вещи"));
                        break;
                    }
                    case "break_stop":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        bool on = a.On ?? true;
                        c.Doc.Set(j, "stop_on_break", on ? "1" : "0");
                        r.Done.Add("диапазон " + (j + 1) + ": " + (on ? "стоп на первом сломе" : "на сломе не останавливается"));
                        break;
                    }
                    case "job_on":
                    {
                        int j = JobOf(c, a.Job, r);
                        if (j < 0) break;
                        c.Doc.Set(j, "on", a.On == false ? "0" : "1");
                        r.Done.Add("диапазон " + (j + 1) + (a.On == false ? " выкл" : " вкл"));
                        break;
                    }
                    case "start":
                    {
                        if (r.Errors.Count > 0) break;           // a setting failed: do not start on the old ones
                        var why = StartProblem(c);
                        if (why.Length > 0)
                        {
                            r.Errors.Add("не старт: " + why);
                            break;
                        }
                        c.Doc.Set(-1, "run", "1");
                        c.Doc.Set(-1, "run_id", NowId());
                        r.Done.Add("старт");
                        break;
                    }
                    case "cryst_now":
                    {
                        if (c.Running) { r.Errors.Add("сначала останови заточку"); break; }
                        if (!c.Live) { r.Errors.Add("бот не на связи"); break; }
                        int n = c.Doc.JobCount;
                        if (!Enumerable.Range(0, n).Any(j => c.Doc.Get(j, "on") != "0" && (c.Doc.Get(j, "cryst") ?? "none") != "none"))
                        {
                            r.Errors.Add("в диапазонах не выбрано, что кристаллизовать");
                            break;
                        }
                        if (!confirmed)
                        {
                            r.Ask = "кристаллизовать? скажи «да»";
                            r.Pending.Add(new VAct { Do = "cryst_now" });
                            break;
                        }
                        c.Doc.Set(-1, "cryst_id", NowId());
                        r.Done.Add("кристаллизую");
                        break;
                    }
                    default:
                        r.Errors.Add("не умею: " + a.Do);
                        break;
                }
            }
            return r;
        }
    }
}
