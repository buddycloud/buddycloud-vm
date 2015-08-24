buddycloud-webclient:
  pkg:
    - installed
    - sources:
      - buddycloud-webclient: http://downloads.buddycloud.com/packages/debian/nightly/webclient/webclient_latest.deb

buddycloud-webclient-bad-config:
  file.absent:
    - name: /etc/buddycloud-webclient/config.js
    - name: /usr/share/buddycloud-webclient/config.js

/usr/share/buddycloud-webclient/config.js:
  file.managed:
    - source: salt://buddycloud-webapps/buddycloud-webclient.js.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - force: True
