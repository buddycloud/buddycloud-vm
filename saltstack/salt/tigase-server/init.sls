tigase-server:
  archive.extracted:
    - name: /opt/tigase-server
    - source: https://projects.tigase.org/attachments/download/1409/tigase-server-5.2.1-b3461-dist-max.tar.gz
    - source_hash: sha256=9cee2d39ea5e958596b2f44d09f8106225462f66c897a2c3101f5691cdb4a2a7
    - tar_options: "z --strip-components=1"
    - archive_format: tar
    - keep: false
    - if_missing: /opt/tigase-server/

/opt/tigase-server/etc/tigase.conf:
  file.managed:
    - source: salt://tigase-server/tigase.conf
    - user: root
    - group: root
    - mode: 644

/opt/tigase-server/etc/init.properties:
  file.managed:
    - source: salt://tigase-server/init.properties
    - user: root
    - group: root
    - mode: 644

/usr/lib/jvm/java-7-oracle/lib/security/UnlimitedJCEPolicy:
  file.recurse:
    - source: salt://tigase-server/UnlimitedJCEPolicy
    - include_empty: True

# Patched with https://projects.tigase.org/attachments/1475/tigase-ibr-cidr-whitelist.patch
/opt/tigase-server/jars/tigase-server.jar:
  file.managed:
    - source: salt://tigase-server/tigase-server.jar
    - user: root
    - group: root
    - mode: 644

Run myscript:
  cmd.run:
    - name: psql -h  127.0.0.1 -U tigase_server tigase_server -f database/postgresql-schema-5-1.sql
    - cwd: /opt/tigase-server
    - env:
      - PGPASSWORD: '{{ salt['pillar.get']('postgres:tigase_server:password') }}'
