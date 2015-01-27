nginx:
  pkg:
    - installed
  service:
    - running

/var/log/nginx:
  file.directory:
    - user: root
    - group: root
    - mode: 0750

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/config/nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /var/log/nginx

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/config/nginx.logrotate
    - user: root
    - group: root
    - mode: 644
