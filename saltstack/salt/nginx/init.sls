/opt/buddycloud-webapp:
  file.directory:
    - makedirs: True

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://nginx/nginx.conf.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja

nginx-firewall-80:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 80
    - proto: tcp
    - sport: 1025:65535
    - save: True

nginx-firewall-443:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 443
    - proto: tcp
    - sport: 1025:65535
    - save: True

nginx-full:
  pkg:
    - installed
  service:
      - running
      - name: nginx
      - watch:
        - pkg: nginx-full
        - file: /etc/nginx/nginx.conf
      - require:
        - pkg: nginx-full
        - file: /opt/buddycloud-webapp
        - file: /etc/nginx/nginx.conf

