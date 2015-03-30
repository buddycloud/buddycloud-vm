postgres:
  pg_hba.conf: salt://postgres/pg_hba.conf

  lookup:
    pkg: 'postgresql-9.3'
    pg_hba: '/etc/postgresql/9.3/main/pg_hba.conf'

  users:
    buddycloud_server_java:
      password: '1198ruj923h4rfasdfasdf'
      createdb: False

    buddycloud_media_server:
      password: '98asdfdaasdddaaa'
      createdb: False

    buddycloud_pusher:
      password: '98addaassdfdaasdddaaa'
      createdb: False

    tigase_server:
      password: 'Ied8eichOasheil0'
      createdb: False

    prosody_server:
      password: 'Ied8eichOasheil0'
      createdb: False

  # This section cover this ACL management of the pg_hba.conf file.
  # <type>, <database>, <user>, [host], <method>
  acls:
    - ['host', 'prosody_server',          'prosody_server',          '0.0.0.0/0']
    - ['host', 'tigase_server',           'tigase_server',           '0.0.0.0/0']
    - ['host', 'buddycloud_server_java',  'buddycloud_server_java',  '0.0.0.0/0']
    - ['host', 'buddycloud_media_server', 'buddycloud_media_server', '0.0.0.0/0']
    - ['host', 'buddycloud_pusher',       'buddycloud_pusher',       '0.0.0.0/0']

  databases:
    prosody_server:
      owner: 'prosody_server'
      user: 'prosody_server'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    tigase_server:
      owner: 'tigase_server'
      user: 'tigase_server'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    buddycloud_server_java:
      owner: 'buddycloud_server_java'
      user: 'buddycloud_server_java'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    buddycloud_pusher:
      owner: 'buddycloud_pusher'
      user: 'buddycloud_pusher'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

    buddycloud_media_server:
      owner: 'buddycloud_media_server'
      user: 'buddycloud_media_server'
      template: 'template0'
      lc_ctype: 'C.UTF-8'
      lc_collate: 'C.UTF-8'

  # This section will append your configuration to postgresql.conf.
  postgresconf: |
    listen_addresses = 'localhost,*'

