"""
PvP focus server: the page pvp.html <-> the bot script pvp_focus.txt, live - no files in between.

    http://127.0.0.1:7790/      the page (pvp.html of this folder): open it in the browser
    127.0.0.1:7791 (TCP)        the bots (pvp_focus.txt on every character), one line per message, CRLF:
        bot -> server:   HELLO|<character>        STATE|<json: what the bot sees, ~3 times a second>
        server -> bot:   RELOAD                   (a profile / the active one changed: read the files now)
                         PING                     (the bot answers PONG)
                         WATCH|1 / WATCH|0        (a page is open / none: the bot builds its STATE only while 1;
                                                   sent on HELLO and when the first page opens / the last closes)
                         STATRESET                (the page: the stats from zero)

The settings stay in files of this folder - the script reads them itself as well (the server may be down: the
keys still work):
    profiles\\<id>.pvp     a profile (windows-1251, as the script reads it)
    pvp.ini               active=<id>: the profile every character uses

Page API (same origin; a change needs the header X-PvP: 1 - another site in the browser cannot make one):
    GET    /api/state                   {"active", "profiles": {id: text}, "bots": {name: state}, "equip": {char: text}}
    PUT    /api/profile?id=<id>         body: the profile text            -> written, the bots told
    DELETE /api/profile?id=<id>
    PUT    /api/active?id=<id>
    PUT    /api/cmd?c=statreset         every bot: its stats from zero
    GET    /api/events                  server-sent events: state, gone, profiles, equip
    GET    /api/skillnames              {id: name} of every skill (Library\\Nav\\skilldb.txt, made from the bot's L2DB)

Run: pvp_server.bat (no window), or "python pvp_server.py" to see its log. One per PC: a second one finds the ports
taken and quits. Log: pvp_server.log next to it. Python 3.8+, nothing to install.
"""

import asyncio
import json
import os
import re
import sys
import time
from urllib.parse import urlparse, parse_qs

DIR = os.path.dirname(os.path.abspath(__file__))
PROF_DIR = os.path.join(DIR, "profiles")
INI = os.path.join(DIR, "pvp.ini")
PAGE = os.path.join(DIR, "pvp.html")
BINDS_DIR = os.path.normpath(os.path.join(DIR, "..", "Binds"))   # the equip binds (their keys: a clash warning)
SKILLDB = os.path.normpath(os.path.join(DIR, "..", "Nav", "skilldb.txt"))   # every skill: id|oper|magic|range|name|...
LOG = os.path.join(DIR, "pvp_server.log")
HOST = "127.0.0.1"
HTTP_PORT = 7790
BOT_PORT = 7791
WATCH_S = 1.0          # the files are looked at this often (a change made outside the page)
BOT_GONE_S = 6.0       # a bot that sent nothing this long is dropped
ID_RE = re.compile(r"^[A-Za-z0-9_-]{1,40}$")

bots = {}              # name -> {"writer", "state", "at"}
pages = set()          # asyncio.Queue of every open page (server-sent events)
files_sig = None       # the profiles / pvp.ini as seen last (names + mtimes)
equip_sig = None
watch_said = None      # the WATCH the bots were told last (1 a page is open, 0 none)


# ---------- small things ----------

def log(*a):
    line = time.strftime("%H:%M:%S ") + " ".join(str(x) for x in a)
    if sys.stdout:
        try:                               # a console that cannot show a name (cp1252...) never stops the server
            print(line.encode(sys.stdout.encoding or "utf-8", errors="replace").decode(sys.stdout.encoding or "utf-8"),
                  flush=True)
        except Exception:
            pass
    try:
        if os.path.exists(LOG) and os.path.getsize(LOG) > 512 * 1024:
            os.replace(LOG, LOG + ".old")
        with open(LOG, "a", encoding="utf-8") as f:
            f.write(line + "\n")
    except OSError:
        pass


def dec(b: bytes) -> str:
    """the bot / the files: utf-8 if it is, else windows-1251"""
    try:
        return b.decode("utf-8")
    except UnicodeDecodeError:
        return b.decode("cp1251", errors="replace")


def read_text(path):
    try:
        with open(path, "rb") as f:
            return dec(f.read())
    except OSError:
        return None


def write_text(path, text):
    """windows-1251 with CRLF (the script reads it so); a temp file swapped in (a reader never sees half of it);
    the script may hold it open a moment: tried again"""
    data = text.replace("\r\n", "\n").replace("\n", "\r\n").encode("cp1251", errors="replace")
    tmp = path + ".tmp"
    with open(tmp, "wb") as f:
        f.write(data)
    for _ in range(20):
        try:
            os.replace(tmp, path)
            return
        except PermissionError:
            time.sleep(0.05)
    with open(path, "wb") as f:            # still held: written in place
        f.write(data)
    try:
        os.remove(tmp)
    except OSError:
        pass


def profiles():
    out = {}
    try:
        names = os.listdir(PROF_DIR)
    except OSError:
        return out
    for n in names:
        if n.lower().endswith(".pvp") and ID_RE.match(n[:-4]):
            t = read_text(os.path.join(PROF_DIR, n))
            if t is not None:
                out[n[:-4]] = t
    return out


def active():
    t = read_text(INI) or ""
    for line in t.splitlines():
        line = line.strip()
        if line.lower().startswith("active="):
            v = line.split("=", 1)[1].strip()
            if ID_RE.match(v):
                return v
    return "main"


def set_active(pid):
    write_text(INI, "; PvP focus: the profile every character uses (Library\\PvP\\profiles\\<id>.pvp). "
                    "Made in pvp.html\nactive=" + pid + "\n")


def equip():
    """the equip binds of every character (Library\\Binds\\<char>.binds): the page warns about the same key"""
    out = {}
    try:
        for n in os.listdir(BINDS_DIR):
            if n.lower().endswith(".binds"):
                t = read_text(os.path.join(BINDS_DIR, n))
                if t:
                    out[n[:-6]] = t
    except OSError:
        pass
    return out


def sig_of(folder, ext, extra=()):
    s = []
    try:
        for n in sorted(os.listdir(folder)):
            if n.lower().endswith(ext):
                try:
                    s.append((n, os.path.getmtime(os.path.join(folder, n))))
                except OSError:
                    pass
    except OSError:
        pass
    for p in extra:
        try:
            s.append((p, os.path.getmtime(p)))
        except OSError:
            pass
    return tuple(s)


# ---------- the pages: server-sent events ----------

def to_pages(event, data):
    msg = ("event: " + event + "\ndata: " + json.dumps(data, ensure_ascii=False) + "\n\n").encode("utf-8")
    for q in list(pages):
        try:
            q.put_nowait(msg)
        except asyncio.QueueFull:      # a page that does not read (asleep): it gets everything again on reconnect
            pass


async def to_bots(line):
    for b in list(bots.values()):
        try:
            b["writer"].write((line + "\r\n").encode("ascii"))
            await b["writer"].drain()
        except (OSError, ConnectionError):
            pass


def watch_now():
    return 1 if pages else 0


async def watch_changed():
    """the first page opened / the last one closed: the bots start / stop building their state"""
    global watch_said
    w = watch_now()
    if w != watch_said:
        watch_said = w
        log("pages open:", len(pages), "-> WATCH|%d" % w)
        await to_bots("WATCH|%d" % w)


# ---------- the bots ----------

async def bot_conn(reader, writer):
    name = None
    peer = writer.get_extra_info("peername")
    try:
        while True:
            raw = await reader.readline()
            if not raw:
                break
            s = dec(raw).rstrip("\r\n")
            if s.startswith("STATE|") and name:
                try:
                    d = json.loads(s[6:])
                except ValueError:
                    continue
                b = bots.get(name)
                if b is None or b["writer"] is not writer:
                    continue
                b["state"] = d
                b["at"] = time.time()
                to_pages("state", {"name": name, "d": d})
            elif s.startswith("HELLO|"):
                name = s[6:].strip() or "?"
                old = bots.get(name)
                if old and old["writer"] is not writer:
                    try:
                        old["writer"].close()
                    except OSError:
                        pass
                bots[name] = {"writer": writer, "state": None, "at": time.time()}
                log("bot", name, "in from", peer)
                writer.write(("WATCH|%d\r\n" % watch_now()).encode("ascii"))   # a page open now or not
                await writer.drain()
            elif s == "PONG" and name in bots:
                bots[name]["at"] = time.time()
    except (OSError, ConnectionError, asyncio.IncompleteReadError, ValueError):   # ValueError: a line over the limit
        pass
    finally:
        if name and name in bots and bots[name]["writer"] is writer:
            del bots[name]
            to_pages("gone", {"name": name})
            log("bot", name, "out")
        try:
            writer.close()
        except OSError:
            pass


# ---------- the page: a tiny HTTP server ----------

def reply(writer, code, body=b"", ctype="text/plain; charset=utf-8", extra=""):
    if isinstance(body, str):
        body = body.encode("utf-8")
    head = ("HTTP/1.1 %d %s\r\nContent-Type: %s\r\nContent-Length: %d\r\nCache-Control: no-store\r\n"
            "Connection: close\r\n%s\r\n") % (code, {200: "OK", 400: "Bad Request", 403: "Forbidden", 404: "Not Found",
                                                     500: "Error"}.get(code, "OK"), ctype, len(body), extra)
    writer.write(head.encode("ascii") + body)


skill_names = None     # {id: name}, read once


def skill_names_json():
    global skill_names
    if skill_names is None:
        names = {}
        try:
            with open(SKILLDB, encoding="utf-8", errors="replace") as f:
                for line in f:
                    if line.startswith("#"):
                        continue
                    p = line.split("|")
                    if len(p) > 4 and p[0].isdigit() and p[4].strip():
                        names[p[0]] = p[4].strip()
        except OSError:
            pass
        skill_names = json.dumps(names, ensure_ascii=False)
    return skill_names


def state_json():
    return json.dumps({"active": active(), "profiles": profiles(),
                       "bots": {n: b["state"] for n, b in bots.items() if b["state"] is not None},
                       "equip": equip()}, ensure_ascii=False)


async def events(writer):
    q = asyncio.Queue(maxsize=400)
    pages.add(q)
    await watch_changed()
    writer.write(b"HTTP/1.1 200 OK\r\nContent-Type: text/event-stream; charset=utf-8\r\nCache-Control: no-store\r\n"
                 b"Connection: keep-alive\r\nX-Accel-Buffering: no\r\n\r\nretry: 1500\n\n")
    try:
        await writer.drain()
        while True:
            try:
                msg = await asyncio.wait_for(q.get(), 15)
            except asyncio.TimeoutError:
                msg = b": ping\n\n"           # keeps the connection: the page sees a dead server at once
            writer.write(msg)
            await writer.drain()
    except (OSError, ConnectionError):
        pass
    finally:
        pages.discard(q)
        try:
            await watch_changed()
        except (OSError, ConnectionError):
            pass


async def http_conn(reader, writer):
    try:
        req = await asyncio.wait_for(reader.readline(), 10)
        if not req:
            return
        try:
            method, target, _ = req.decode("latin1").split(" ", 2)
        except ValueError:
            reply(writer, 400, "bad request")
            return
        headers = {}
        while True:
            h = await asyncio.wait_for(reader.readline(), 10)
            if h in (b"\r\n", b"\n", b""):
                break
            k, _, v = h.decode("latin1").partition(":")
            headers[k.strip().lower()] = v.strip()
        n = int(headers.get("content-length") or 0)
        body = await asyncio.wait_for(reader.readexactly(n), 10) if 0 < n < 4_000_000 else b""
        # only this PC by its own name (a site renamed to 127.0.0.1 - DNS rebinding - gets nothing)
        host = headers.get("host", "").split(":")[0].lower()
        if host not in ("127.0.0.1", "localhost"):
            reply(writer, 403, "forbidden")
            return
        u = urlparse(target)
        q = parse_qs(u.query)
        path = u.path
        pid = (q.get("id") or [""])[0]
        if method == "GET" and path in ("/", "/pvp.html", "/index.html"):
            try:
                with open(PAGE, "rb") as f:
                    reply(writer, 200, f.read(), "text/html; charset=utf-8")
            except OSError:
                reply(writer, 404, "no pvp.html next to the server")
            return
        if method == "GET" and path == "/api/state":
            reply(writer, 200, state_json(), "application/json; charset=utf-8")
            return
        if method == "GET" and path == "/api/skillnames":
            reply(writer, 200, skill_names_json(), "application/json; charset=utf-8")
            return
        if method == "GET" and path == "/api/events":
            await events(writer)
            return
        if method in ("PUT", "POST", "DELETE"):
            if headers.get("x-pvp") != "1":          # a plain cross-site form cannot set it
                reply(writer, 403, "forbidden")
                return
            if path == "/api/profile" and ID_RE.match(pid):
                p = os.path.join(PROF_DIR, pid + ".pvp")
                if method == "DELETE":
                    try:
                        os.remove(p)
                    except OSError:
                        pass
                    log("profile", pid, "deleted")
                else:
                    os.makedirs(PROF_DIR, exist_ok=True)
                    write_text(p, dec(body))
                await changed_files()
                reply(writer, 200, "ok")
                return
            if path == "/api/cmd" and (q.get("c") or [""])[0] == "statreset":
                await to_bots("STATRESET")
                log("stats reset")
                reply(writer, 200, "ok")
                return
            if path == "/api/active" and ID_RE.match(pid):
                set_active(pid)
                log("active ->", pid)
                await changed_files()
                reply(writer, 200, "ok")
                return
        reply(writer, 404, "not found")
    except (OSError, ConnectionError, asyncio.TimeoutError, asyncio.IncompleteReadError, ValueError):
        pass
    finally:
        try:
            await writer.drain()
            writer.close()
        except (OSError, ConnectionError):
            pass


# ---------- the files: a change (by the page or by hand) -> the bots and the pages ----------

async def changed_files():
    global files_sig
    files_sig = sig_of(PROF_DIR, ".pvp", (INI,))
    await to_bots("RELOAD")
    to_pages("profiles", {"active": active(), "profiles": profiles()})


async def watcher():
    global files_sig, equip_sig
    files_sig = sig_of(PROF_DIR, ".pvp", (INI,))
    equip_sig = sig_of(BINDS_DIR, ".binds")
    n = 0
    while True:
        await asyncio.sleep(WATCH_S)
        n += 1
        s = sig_of(PROF_DIR, ".pvp", (INI,))
        if s != files_sig:
            log("files changed outside the page")
            await changed_files()
        if n % 5 == 0:
            e = sig_of(BINDS_DIR, ".binds")
            if e != equip_sig:
                equip_sig = e
                to_pages("equip", equip())
            if n % 10 == 0:
                await to_bots("PING")
            now = time.time()
            for name, b in list(bots.items()):
                if now - b["at"] > BOT_GONE_S * 3:     # silent this long: the bot hung / the game closed
                    try:
                        b["writer"].close()
                    except OSError:
                        pass


async def main():
    os.makedirs(PROF_DIR, exist_ok=True)
    try:
        web = await asyncio.start_server(http_conn, HOST, HTTP_PORT)
        bot = await asyncio.start_server(bot_conn, HOST, BOT_PORT, limit=4 * 1024 * 1024)   # a STATE line: 150 players
    except OSError as e:
        log("ports %d / %d taken (%s): the server runs already - this one quits" % (HTTP_PORT, BOT_PORT, e))
        return
    log("PvP server: page http://%s:%d/  bots %s:%d  folder %s" % (HOST, HTTP_PORT, HOST, BOT_PORT, DIR))
    asyncio.ensure_future(watcher())
    async with web, bot:
        await asyncio.gather(web.serve_forever(), bot.serve_forever())


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
