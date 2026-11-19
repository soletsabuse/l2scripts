using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

namespace PvpPanel
{
    /// <summary>What the server says now. Up = false: it does not answer (not running).</summary>
    sealed class ServerStatus
    {
        public bool Up;
        public string Active = "";
        public List<string> Online = new List<string>();
        public int Pages;          // pages with live events open (the bots build their state only while > 0)
        public int Pid;            // the server process (0: an old server that does not say it)
        public bool Old;           // an old server with no /api/status (the bots of it: only the ones that sent a state)
        public string Error = "";  // the panel's server did not start: why
    }

    /// <summary>pvp_server.py over its page API (127.0.0.1:7790). A change carries the header X-PvP: 1.</summary>
    sealed class ServerClient
    {
        static readonly HttpClient Http = new HttpClient
        {
            BaseAddress = new Uri(Paths.PageUrl),
            Timeout = TimeSpan.FromMilliseconds(1500),
        };

        public async Task<ServerStatus> GetStatusAsync()
        {
            var st = new ServerStatus();
            try
            {
                using var r = await Http.GetAsync("api/status");
                if (r.StatusCode == HttpStatusCode.NotFound)
                    return await GetOldStatusAsync();
                if (!r.IsSuccessStatusCode) return st;
                using var doc = JsonDocument.Parse(await r.Content.ReadAsStringAsync());
                var root = doc.RootElement;
                st.Up = true;
                if (root.TryGetProperty("active", out var a)) st.Active = a.GetString() ?? "";
                if (root.TryGetProperty("pages", out var p) && p.ValueKind == JsonValueKind.Number) st.Pages = p.GetInt32();
                if (root.TryGetProperty("pid", out var pid) && pid.ValueKind == JsonValueKind.Number) st.Pid = pid.GetInt32();
                if (root.TryGetProperty("online", out var on) && on.ValueKind == JsonValueKind.Array)
                    foreach (var n in on.EnumerateArray())
                        if (n.GetString() is string s) st.Online.Add(s);
            }
            catch (HttpRequestException) { }
            catch (TaskCanceledException) { }
            catch (JsonException) { }
            return st;
        }

        /// <summary>A server from before /api/status: its full state (the bots that sent a state only).</summary>
        async Task<ServerStatus> GetOldStatusAsync()
        {
            var st = new ServerStatus { Old = true };
            try
            {
                using var r = await Http.GetAsync("api/state");
                if (!r.IsSuccessStatusCode) return st;
                using var doc = JsonDocument.Parse(await r.Content.ReadAsStringAsync());
                var root = doc.RootElement;
                st.Up = true;
                if (root.TryGetProperty("active", out var a)) st.Active = a.GetString() ?? "";
                if (root.TryGetProperty("bots", out var b) && b.ValueKind == JsonValueKind.Object)
                    foreach (var p in b.EnumerateObject())
                        st.Online.Add(p.Name);
                st.Online.Sort(StringComparer.OrdinalIgnoreCase);
            }
            catch (HttpRequestException) { }
            catch (TaskCanceledException) { }
            catch (JsonException) { }
            return st;
        }

        public async Task<bool> PutAsync(string pathAndQuery)
        {
            try
            {
                using var req = new HttpRequestMessage(HttpMethod.Put, pathAndQuery)
                {
                    Content = new ByteArrayContent(Array.Empty<byte>()),
                };
                req.Headers.Add("X-PvP", "1");
                using var r = await Http.SendAsync(req);
                return r.IsSuccessStatusCode;
            }
            catch (HttpRequestException) { return false; }
            catch (TaskCanceledException) { return false; }
        }

        public Task<bool> SetActiveAsync(string id) => PutAsync("api/active?id=" + Uri.EscapeDataString(id));
        public Task<bool> StatResetAsync() => PutAsync("api/cmd?c=statreset");
        public Task<bool> QuitAsync() => PutAsync("api/cmd?c=quit");
    }

    /// <summary>The old Python server (pvp_server.py) holding the ports: stopped so the panel's own server takes them.
    /// Never any other python: by its own pid (it says it) or by the command line holding pvp_server.py (the user runs
    /// other Python servers of his own).</summary>
    static class ServerProcess
    {
        /// <summary>Stop it: the quit command; no answer -> its pid (the server says it); an old server -> the python
        /// process whose command line holds pvp_server.py. Waits until it is down (3 s).</summary>
        public static async Task<bool> StopAsync(ServerClient client, ServerStatus st)
        {
            if (!await client.QuitAsync())
            {
                if (st.Pid > 0)
                {
                    try { Process.GetProcessById(st.Pid).Kill(); }
                    catch (ArgumentException) { }
                    catch (InvalidOperationException) { }
                    catch (Win32Exception) { }
                }
                else
                    KillByCommandLine();
            }
            for (int i = 0; i < 30; i++)
            {
                await Task.Delay(100);
                if (!(await client.GetStatusAsync()).Up) return true;
            }
            return false;
        }

        static void KillByCommandLine()
        {
            const string ps = "Get-CimInstance Win32_Process | Where-Object { $_.Name -like 'python*' -and " +
                              "$_.CommandLine -like '*pvp_server.py*' -and $_.ProcessId -ne $PID } | " +
                              "ForEach-Object { Stop-Process -Id $_.ProcessId -Force }";
            try
            {
                var psi = new ProcessStartInfo("powershell", "-NoProfile -NonInteractive -Command \"" + ps + "\"")
                {
                    UseShellExecute = false,
                    CreateNoWindow = true,
                };
                using var p = Process.Start(psi);
                p?.WaitForExit(5000);
            }
            catch (Win32Exception) { }
        }
    }
}
