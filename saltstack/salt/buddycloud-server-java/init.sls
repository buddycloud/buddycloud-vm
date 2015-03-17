buddycloud-server-java:
  pkg:
    - installed
    - sources:
      - buddycloud-server-java: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_latest.deb
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: buddycloud-server-java

create-buddycloud-server-schema:
  cmd.run:
    - name: psql -h 127.0.0.1 -U buddycloud_server_java buddycloud_server_java -f /usr/share/dbconfig-common/data/buddycloud-server-java/install/pgsql
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:users:buddycloud_server_java:password') }}'

/etc/dbconfig-common/buddycloud-server-java.conf:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java.dbconfig.conf.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/usr/share/buddycloud-server-java/configuration.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-configuration.properties.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/usr/share/buddycloud-server-java/log4j.properties:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java-log4j.properties
    - user: root
    - group: root
    - mode: 0644

buddycloud-server-java-service:
  service.running:
    - enable: True
    - name: buddycloud-server-java

