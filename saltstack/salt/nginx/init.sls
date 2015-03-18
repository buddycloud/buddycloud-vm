/opt/buddycloud-webapp:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: true
    - recurse:
      - user
      - group
      - mode

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://nginx/nginx.conf.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja

nginx:
  pkg:
    - installed
  service.running:
      - enable: true
      - reload: true
      - watch:
        - pkg: nginx
        - file: /etc/nginx/nginx.conf
      - require:
        - pkg: nginx
        - file: /opt/buddycloud-webapp
        - file: /etc/nginx/nginx.conf

