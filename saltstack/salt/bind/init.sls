bind-server:
  pkg.installed:
    - name: bind9
  file.managed:
    - name: /etc/bind/named.conf.options
    - source: salt://bind/named.conf.options.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

/etc/bind/named.conf.local:
  file.managed:
    - source: salt://bind/named.conf.local.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

/etc/bind/db.buddycloud:
  file.managed:
    - source: salt://bind/db.buddycloud.template
    - user: bind
    - group: bind
    - mode: 0644
    - template: jinja
    - require:
      - pkg: bind9

bind-firewall-53-udp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 53
    - proto: udp
    - save: True

bind-firewall-53-tcp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 53
    - proto: tcp
    - save: True
