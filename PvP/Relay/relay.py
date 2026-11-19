#!/usr/bin/env python3
"""PvP relay: passes the targets (and later other things) between the PvP panels of a party, one TCP link per PC.

The panel (PvpPanel) keeps the link and puts its characters in a room; the relay sends a line of one link to every
other link of the room at once (TCP_NODELAY, nothing waits). Lines are UTF-8, '\n' ends them ('\r\n' is fine too).

  panel -> relay:  HELLO|<key>|<room>|<ver>     the first line, within HELLO_S, or the link is closed
                   JOIN|<char>  LEAVE|<char>      the characters of this PC in the room
                   T|<char>|<oid>|<name>          the target of a character of this link now (oid 0 = none)
                   X|<char>|<payload>             anything else for the room (later things), passed as it is
                   P|<token>                      ping: the same line back
  relay -> panel:  WELCOME|<ver>
                   ROOM|<char>,<char>,...         everyone in the room (all links), after every change
                   T|<char>|<oid>|<name>          a target of another link (on WELCOME / JOIN: everyone's now)
                   X|<char>|<payload>   P|<token>   BYE|<reason> (then closed)

The key: $CREDENTIALS_DIRECTORY/key (systemd LoadCredential) or RELAY_KEY. The port: RELAY_PORT (7795).
"""
import asyncio
import hmac
import os
import socket
import sys
import time

VER = '1'
PORT = int(os.environ.get('RELAY_PORT', '7795'))
MAX_LINE = 1024          # a longer line: the link is closed
HELLO_S = 5              # the HELLO must come this soon
SILENT_S = 30            # a link that sends nothing this long is closed (the panel pings every 2 s)
MAX_LINKS = 200
MAX_PER_IP = 16
MAX_CHARS = 24           # characters per link
RATE = 40.0              # lines per second per link (a burst of BURST)
BURST = 120.0
SLOW_BYTES = 256 * 1024  # a link that does not read: closed instead of piling up


def load_key():
    d = os.environ.get('CREDENTIALS_DIRECTORY')
    if d and os.path.exists(os.path.join(d, 'key')):
        with open(os.path.join(d, 'key'), encoding='utf-8') as f:
            return f.read().strip()
    return os.environ.get('RELAY_KEY', '').strip()


KEY = load_key()


def log(text):
    print(time.strftime('%H:%M:%S ') + text, flush=True)


class Room:
    def __init__(self, name):
        self.name = name
        self.links = set()
        self.chars = {}       # lower name -> (name, link)
        self.targets = {}     # lower name -> 'T|...' line (bytes)


class Link:
    def __init__(self, writer, ip):
        self.w = writer
        self.ip = ip
        self.room = None
        self.chars = set()    # lower names
        self.tokens = BURST
        self.tok_at = time.monotonic()
        self.closed = False

    def send(self, data):
        if self.closed:
            return
        try:
            self.w.write(data)
            if self.w.transport.get_write_buffer_size() > SLOW_BYTES:
                log('slow link %s: closed' % self.ip)
                self.close()
        except (ConnectionError, RuntimeError):
            self.close()

    def close(self):
        if not self.closed:
            self.closed = True
            try:
                self.w.close()
            except Exception:
                pass

    def allow(self):
        now = time.monotonic()
        self.tokens = min(BURST, self.tokens + (now - self.tok_at) * RATE)
        self.tok_at = now
        if self.tokens < 1:
            return False
        self.tokens -= 1
        return True


rooms = {}
links = set()
per_ip = {}
bad_log_at = {}


def room_line(room):
    names = sorted((n for n, _ in room.chars.values()), key=str.lower)
    return ('ROOM|' + ','.join(names) + '\n').encode('utf-8')


def to_room(room, data, but=None):
    for l in list(room.links):
        if l is not but:
            l.send(data)


def drop_char(link, low):
    room = link.room
    link.chars.discard(low)
    if room and low in room.chars and room.chars[low][1] is link:
        del room.chars[low]
        room.targets.pop(low, None)
        return True
    return False


def leave_room(link):
    room = link.room
    if not room:
        return
    changed = False
    for low in list(link.chars):
        changed |= drop_char(link, low)
    room.links.discard(link)
    link.room = None
    if not room.links:
        rooms.pop(room.name, None)
    elif changed:
        to_room(room, room_line(room))


def tune(sock):
    try:
        sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
        for opt, val in (('TCP_KEEPIDLE', 15), ('TCP_KEEPINTVL', 5), ('TCP_KEEPCNT', 3)):
            if hasattr(socket, opt):
                sock.setsockopt(socket.IPPROTO_TCP, getattr(socket, opt), val)
    except OSError:
        pass


async def handle(reader, writer):
    peer = writer.get_extra_info('peername') or ('?', 0)
    ip = peer[0]
    sock = writer.get_extra_info('socket')
    if sock is not None:
        tune(sock)
    if len(links) >= MAX_LINKS or per_ip.get(ip, 0) >= MAX_PER_IP:
        writer.close()
        return
    link = Link(writer, ip)
    links.add(link)
    per_ip[ip] = per_ip.get(ip, 0) + 1
    try:
        # the HELLO first
        try:
            raw = await asyncio.wait_for(reader.readuntil(b'\n'), HELLO_S)
        except (asyncio.TimeoutError, asyncio.IncompleteReadError, asyncio.LimitOverrunError, ConnectionError):
            return
        p = raw.decode('utf-8', 'replace').strip().split('|')
        if len(p) < 3 or p[0] != 'HELLO' or not KEY or not hmac.compare_digest(p[1].encode(), KEY.encode()):
            now = time.monotonic()
            if now - bad_log_at.get(ip, 0) > 60:
                bad_log_at[ip] = now
                log('bad hello from %s' % ip)
            await asyncio.sleep(0.5)
            link.send(b'BYE|key\n')
            return
        rname = p[2].strip()[:40] or 'main'
        room = rooms.get(rname)
        if room is None:
            room = rooms[rname] = Room(rname)
        link.room = room
        room.links.add(link)
        link.send(('WELCOME|' + VER + '\n').encode())
        link.send(room_line(room))
        for low, line in room.targets.items():
            if room.chars.get(low, (None, None))[1] is not link:
                link.send(line)
        log('link %s in room %s (%d links)' % (ip, rname, len(room.links)))
        while not link.closed:
            try:
                raw = await asyncio.wait_for(reader.readuntil(b'\n'), SILENT_S)
            except asyncio.TimeoutError:
                log('link %s silent: closed' % ip)
                return
            except (asyncio.IncompleteReadError, asyncio.LimitOverrunError, ConnectionError):
                return
            if not link.allow():
                link.send(b'BYE|too fast\n')
                log('link %s too fast: closed' % ip)
                return
            line = raw.decode('utf-8', 'replace').rstrip('\r\n')
            kind, _, rest = line.partition('|')
            if kind == 'P':
                link.send((line + '\n').encode('utf-8'))
            elif kind == 'T' or kind == 'X':
                who = rest.partition('|')[0].strip()
                low = who.lower()
                if low not in link.chars:
                    continue                                  # not a character of this link
                data = (line + '\n').encode('utf-8')
                if kind == 'T':
                    room.targets[low] = data
                to_room(room, data, but=link)
            elif kind == 'JOIN':
                who = rest.strip()[:32]
                low = who.lower()
                if not who or '|' in who or ',' in who or (low not in link.chars and len(link.chars) >= MAX_CHARS):
                    continue
                old = room.chars.get(low)
                if old and old[1] is not link:                # the character moved to this PC / came back
                    old[1].chars.discard(low)
                    room.targets.pop(low, None)
                link.chars.add(low)
                room.chars[low] = (who, link)
                to_room(room, room_line(room))
                log('%s joined room %s from %s' % (who, rname, ip))
            elif kind == 'LEAVE':
                low = rest.strip().lower()
                if drop_char(link, low):
                    to_room(room, room_line(room))
                    log('%s left room %s' % (rest.strip(), rname))
    finally:
        leave_room(link)
        links.discard(link)
        per_ip[ip] = per_ip.get(ip, 1) - 1
        if per_ip[ip] <= 0:
            per_ip.pop(ip, None)
        link.close()


async def main():
    if not KEY:
        log('no key (LoadCredential key / RELAY_KEY): not starting')
        sys.exit(2)
    srv = await asyncio.start_server(handle, host=None, port=PORT, limit=MAX_LINE, reuse_address=True, backlog=64)
    log('PvP relay %s on port %d' % (VER, PORT))
    async with srv:
        await srv.serve_forever()


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
