buddycloud-http-api-dependencies:
  pkg.installed:
    - pkgs:
      - software-properties-common
      - python-software-properties
      - libicu-dev
      - nodejs

buddycloud-http-api:
  pkg:
    - installed
    - sources:
      - buddycloud-http-api: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_latest.deb

/usr/share/buddycloud-http-api/config.js:
  file.managed:
    - source: salt://buddycloud-http-api/config.js
    - user: root
    - group: root
    - mode: 644

/etc/init.d/buddycloud-http-api:
  service.running:
    - name: buddycloud-http-api
    - enable: True
    - restart: True
    - reload: True
    - require:
      - file: /usr/share/buddycloud-http-api/config.js
    - watch: 
      - file: /usr/share/buddycloud-http-api/config.js

