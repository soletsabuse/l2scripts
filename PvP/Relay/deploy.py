"""Deploys the PvP relay (relay.py + pvp-relay.service) to the server of relay.ini and restarts it.

  python deploy.py            upload, restart, check that it answers
  python deploy.py status     the service state and its last log lines

SSH: the key ~/.ssh/pvp_relay and the checked host keys ~/.ssh/pvp_relay_known_hosts (made once, by hand).
The relay key goes from relay.ini to /etc/pvp-relay/key (through stdin: never on a command line).
"""
import os
import socket
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
INI = os.path.join(HERE, '..', 'relay.ini')
SSH_KEY = os.path.expanduser('~/.ssh/pvp_relay')
KNOWN = os.path.expanduser('~/.ssh/pvp_relay_known_hosts')


def ini():
    cfg = {}
    with open(INI, encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith(';') and '=' in line:
                k, v = line.split('=', 1)
                cfg[k.strip()] = v.strip()
    return cfg


CFG = ini()
HOST, PORT, KEY = CFG['host'], int(CFG.get('port', '7795')), CFG['key']


def ssh(cmd, data=None):
    args = ['ssh', '-i', SSH_KEY, '-o', 'UserKnownHostsFile=' + KNOWN, '-o', 'StrictHostKeyChecking=yes',
            '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', 'root@' + HOST, cmd]
    r = subprocess.run(args, input=data, capture_output=True)
    out = (r.stdout + r.stderr).decode('utf-8', 'replace').strip()
    if r.returncode != 0:
        raise SystemExit('ssh failed (%d): %s\n%s' % (r.returncode, cmd, out))
    return out


def put(local, remote, mode):
    with open(local, 'rb') as f:
        data = f.read().replace(b'\r\n', b'\n')
    ssh('umask 077; cat > %s.new && chmod %s %s.new && mv -f %s.new %s' % (remote, mode, remote, remote, remote), data)


def answers():
    """HELLO with the key -> WELCOME: the relay is up and the port is open from here."""
    t = time.perf_counter()
    s = socket.create_connection((HOST, PORT), timeout=5)
    ms = (time.perf_counter() - t) * 1000
    s.sendall(('HELLO|' + KEY + '|deploy-check|1\n').encode())
    s.settimeout(5)
    got = s.recv(200).decode('utf-8', 'replace')
    s.close()
    return got.startswith('WELCOME|'), ms, got.strip()


def main():
    if len(sys.argv) > 1 and sys.argv[1] == 'status':
        print(ssh('systemctl is-active pvp-relay; journalctl -u pvp-relay -n 15 --no-pager -o cat'))
        return
    ssh('install -d -m 755 /opt/pvp-relay && install -d -m 700 /etc/pvp-relay')
    ssh('umask 077; cat > /etc/pvp-relay/key.new && mv -f /etc/pvp-relay/key.new /etc/pvp-relay/key', KEY.encode())
    put(os.path.join(HERE, 'relay.py'), '/opt/pvp-relay/relay.py', '644')
    put(os.path.join(HERE, 'pvp-relay.service'), '/etc/systemd/system/pvp-relay.service', '644')
    print(ssh('systemctl daemon-reload && systemctl enable pvp-relay >/dev/null 2>&1; systemctl restart pvp-relay && '
              'sleep 1 && systemctl is-active pvp-relay'))
    print(ssh("ufw status | grep -q '^%d/tcp ' || ufw allow %d/tcp comment 'PvP relay' ; ufw status | grep '^%d/tcp'"
              % (PORT, PORT, PORT)))
    ok, ms, got = answers()
    print(('relay answers' if ok else 'relay does NOT answer') + ' (%s:%d, connect %.0f ms): %s' % (HOST, PORT, ms, got))
    if not ok:
        sys.exit(1)


if __name__ == '__main__':
    main()
