media-server-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl

create media account:
  cmd.script:
    - name: create-media-account.sh
    - source: salt://buddycloud-media-server/create-media-account.sh

buddycloud-media-server:
  pkg:
    - installed
    - sources:
      - buddycloud-media-server: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-media-server/buddycloud-media-server_latest.deb
    - service:
      - running

/usr/share/buddycloud-media-server/mediaserver.properties:
  file.managed:
    - source: salt://buddycloud-media-server/mediaserver.properties
    - user: root
    - group: root
    - mode: 644

/usr/share/buddycloud-media-server/logback.xml:
  file.managed:
    - source: salt://buddycloud-media-server/logback.xml
    - user: root
    - group: root
    - mode: 644
