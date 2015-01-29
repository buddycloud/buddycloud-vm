postgres:
  pg_hba.conf: salt://postgres/pg_hba.conf

  lookup:
    pkg: 'postgresql-9.3'
    pg_hba: '/etc/postgresql/9.3/main/pg_hba.conf'

  users:
    buddycloud-server-java:
      password: '1198ruj923h4rfasdfasdf'
      createdb: False

    buddycloud-media-server:
      password: '98asdfdaasdddaaa'
      createdb: False

  # This section cover this ACL management of the pg_hba.conf file.
  # <type>, <database>, <user>, [host], <method>
  acls:
    - ['host', 'buddycloud-server-java', 'buddycloud-server-java', '0.0.0.0/0']
    - ['host', 'buddycloud-media-server', 'buddycloud-media-server', '0.0.0.0/0']

  databases:
    buddycloud-server-java:
      owner: 'buddycloud-server-java'
      user: 'buddycloud-server-java'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    buddycloud-media-server:
      owner: 'buddycloud-media-server'
      user: 'buddycloud-media-server'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

  # This section will append your configuration to postgresql.conf.
  postgresconf: |
    listen_addresses = 'localhost,*'

