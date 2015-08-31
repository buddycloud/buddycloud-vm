postgres:
  pg_hba.conf: salt://postgres/pg_hba.conf

  lookup:
    pkg: 'postgresql-9.3'
    pg_hba: '/etc/postgresql/9.3/main/pg_hba.conf'

  users:
    {% for env in ['dev'] %}
    {% for db in ['buddycloudserver','hosting','mediaserver','tigase','friendfinder','prosody','pusher','channeldirectory'] %} 
    {{ env }}_{{ db }}:
      password: '{{ env }}_secret'
      createdb: False
      connlimit: 10
    {% endfor %}
    {% endfor %}

  # This section cover this ACL management of the pg_hba.conf file.
  # <type>, <database>, <user>, [host], <method>
  acls:
    - ['host', 'all',                       'all',                      '::1/128']
    - ['host', 'all',                       'all',                      '127.0.0.1/32']
    
  databases:
    {% for env in ['dev'] %}
    {% for db in ['buddycloudserver','hosting','mediaserver','tigase','friendfinder','prosody','pusher','channeldirectory'] %} 
    {{ env }}_{{ db }}:
      owner: '{{ env }}_{{ db }}'
      user: '{{ env }}_{{ db }}'
      template: 'template0'
      lc_ctype: 'en_GB.UTF-8'
      lc_collate: 'en_GB.UTF-8'
    {% endfor %}
    {% endfor %}

  # This section will append your configuration to postgresql.conf.
  postgresconf: |
    listen_addresses = '*'

