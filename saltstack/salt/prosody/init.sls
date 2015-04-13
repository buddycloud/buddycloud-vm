#
# Prosody - jabber server
#

prosody-repo:
  pkgrepo.managed:
   - name: deb http://packages.prosody.im/debian trusty main
   - key_url: http://packages.prosody.im/debian/pubkey.asc
   - require_in:
     - pkg: prosody

prosody-packages:
  pkg.installed:
    - pkgs:
      - lua-dbi-postgresql # postgresql adapter
      - lua-zlib  # mod_compression
      - lua-sec   # ssl & auth
      - lua-event # use_libevent
      - lua-bitop # mod_websockets
      - prosody-0.10
    - require:
      - pkgrepo: prosody-repo

/var/tmp/reset-tokens.sql:
  file.managed:
    - source: salt://prosody/reset-tokens.sql

create-password-recovery-schema:
  cmd.run:
    - name: psql -h 127.0.0.1 -U prosody_server prosody_server -f /var/tmp/reset-tokens.sql
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:users:prosody_server:password') }}'

prosody:
  service.running:
    - require:
      - pkg: prosody-packages
    - enable: True
    - full_restart: True
    - force_reload: True
    - watch:
      - file: /etc/prosody/prosody.cfg.lua

/etc/prosody/modules:
  file.recurse:
    - source: salt://prosody/modules
    - user: root
    - group: root
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - require_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

/etc/prosody/prosody.cfg.lua:
  file.managed:
    - source: salt://prosody/prosody.cfg.lua.jinja
    - template: jinja
    - user: root
    - group: prosody
    - mode: 640
    - watch_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

prosody-firewall-c2s:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 5222
    - proto: tcp
    - save: True

prosody-firewall-s2s:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 5269
    - proto: tcp
    - save: True

prosody-firewall-temp-lloyd:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 5432
    - proto: tcp
    - save: True

