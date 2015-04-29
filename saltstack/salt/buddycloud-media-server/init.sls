media-server-dependencies:
  pkg.installed:
    - pkgs:
      - postgresql-client
      - dbconfig-common 
      - libssl1.0.0
      - openssl
      - openjdk-7-jre-headless

buddycloud-media-server:
  pkg:
    - installed
    - sources:
      - buddycloud-media-server: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-media-server/buddycloud-media-server_latest.deb
    - service:
      - running

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

create-buddycloud-media-server-schema:
  cmd.run:
    - name: psql -h 127.0.0.1 -U buddycloud_media_server buddycloud_media_server -f /usr/share/dbconfig-common/data/buddycloud-media-server/install/pgsql
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:users:buddycloud_media_server:password') }}'

create-media-xmpp-user-account:
  cmd.run:
    - name: echo -e "{{ salt['pillar.get']('buddycloud:lookup:media-jid-password') }}\n{{ salt['pillar.get']('buddycloud:lookup:media-jid-password') }}" | prosodyctl adduser mediaserver-test@{{ salt['pillar.get']('buddycloud:lookup:domain') }} | true 

/etc/init.d/buddycloud-media-server:
  file.managed:
    - source: salt://buddycloud-media-server/buddycloud-media-server.init.d
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: buddycloud-media-server
    - enable: True
    - force_reload: True
    - full_restart: True
    - require:
      - pkg: buddycloud-server-java
      - pkg: buddycloud-media-server
      - pkg: media-server-dependencies
      - file: /usr/share/buddycloud-media-server/mediaserver.properties
      - file: /usr/share/buddycloud-media-server/logback.xml
      - cmd: create-buddycloud-media-server-schema
      - cmd: create-media-xmpp-user-account

