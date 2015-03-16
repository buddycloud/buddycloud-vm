install-media-server-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl

/srv/buddycloud-media-server-filestore:
    file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - recurse:
        - user
        - group
        - mode

create-media-xmpp-user-account:
  cmd.run:
    - name: psql -h 127.0.0.1 -U tigase_server tigase_server -c "SELECT TigAddUserPlainPw('mediaserver-test@buddycloud.com', 'mediaserver-test');"
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:users:tigase_server:password') }}'

buddycloud-media-server:
  pkg:
    - installed
    - sources:
      - buddycloud-media-server: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-media-server/buddycloud-media-server_latest.deb
    - service:
      - running

/usr/share/buddycloud-media-server/mediaserver.properties:
  file.managed:
    - source: salt://buddycloud-media-server/mediaserver.properties.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/usr/share/buddycloud-media-server/logback.xml:
  file.managed:
    - source: salt://buddycloud-media-server/logback.xml
    - user: root
    - group: root
    - mode: 644

