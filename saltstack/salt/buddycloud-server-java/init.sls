buddycloud-server-java:
  pkg:
    - installed
    - sources:
      - buddycloud-server-java: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-server-java/buddycloud-server-java_latest.deb

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

/etc/init.d/buddycloud-server-java:
  file.managed:
    - source: salt://buddycloud-server-java/buddycloud-server-java.init.d
    - user: root
    - group: root
    - mode: 0755
  service.running:
    - name: buddycloud-server-java
    - enable: True
    - reload: True
    - require:
      - pkg: postgresql-9.3
      - pkg: oracle-java7-installer
      - pkg: buddycloud-server-java
      - file: /usr/share/buddycloud-server-java/configuration.properties
      - file: /usr/share/buddycloud-server-java/log4j.properties
      - file: /etc/dbconfig-common/buddycloud-server-java.conf
      - file: /etc/init.d/buddycloud-server-java
      - cmd: create-buddycloud-server-schema
