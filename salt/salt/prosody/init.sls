#
# Prosody - jabber server
#
# TODO: Prosody service status
#

{% set admin_user = salt['pillar.get']('mail:admin', 'root') %}

{% set db_type = salt['pillar.get']('prosody:db_type', 'SQLite3') %}
{% set db_path = salt['pillar.get']('prosody:db_path', 'prosody.sqlite') %}
{% set db_name = salt['pillar.get']('prosody:db_name', 'prosody') %}
{% set db_user = salt['pillar.get']('prosody:db_user', '') %}
{% set db_password = salt['pillar.get']('prosody:db_password', '') %}

{% set ldap_server = salt['pillar.get']('prosody:ldap_server', '') %}
{% set ldap_userbase = salt['pillar.get']('prosody:ldap_userbase', 'ou=Users,dc=example,dc=net') %}
{% set ldap_filter = salt['pillar.get']('prosody:ldap_filter', '(cn=$user@$host)') %}

prosody-repo:
  pkgrepo.managed:
   - name: deb http://packages.prosody.im/debian trusty main
   - key_url: http://packages.prosody.im/debian/pubkey.asc
   - require_in:
     - pkg: prosody

prosody-packages:
  pkg.installed:
    - pkgs:
      - lua-dbi-postgresql # postgresql adapter
      - lua-zlib  # mod_compression
      - lua-sec-prosody   # ssl & auth
      - lua-event # use_libevent
      - lua-bitop # mod_websockets
      - lua-ldap # mod_auth_ldap
      - prosody-0.10
    - require:
      - pkgrepo: prosody-repo

prosody:
  service.running:
    - require:
      - pkg: prosody-packages

/etc/prosody/modules:
  file.recurse:
    - source: salt://prosody/modules
    - user: root
    - group: root
    - clean: True
    - dir_mode: 755
    - file_mode: 644
    - require_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

/etc/prosody/sharedgroups.ini:
  file.managed:
    - user: root
    - group: prosody
    - mode: 640
    - contents: |
{%- for group, users in salt['pillar.get']('prosody:groups', {})|dictsort %}
        [{{ group }}]
{%- for login, name in users|dictsort %}
        {{ login }}={{ name.decode('unicode-escape') }}
{%- endfor %}
{%- endfor %}
    - require:
      - pkg: prosody-packages
    - watch_in:
      - service: prosody

/etc/prosody/prosody.cfg.lua:
  file.managed:
    - source: salt://prosody/prosody.cfg.lua.jinja
    - template: jinja
    - user: root
    - group: prosody
    - mode: 640
    - context:
      admin_user: {{ admin_user }}
      db_type: {{ db_type }}
      db_path: {{ db_path }}
      db_name: {{ db_name }}
      db_user: {{ db_user }}
      db_password: {{ db_password }}
      ldap_server: {{ ldap_server }}
      ldap_userbase: {{ ldap_userbase }}
      ldap_filter: {{ ldap_filter }}
    - watch_in:
      - service: prosody
    - require:
      - pkg: prosody-packages

/etc/prosody/conf.avail:
  file.directory:
    - user: prosody
    - group: prosody
    - mode: 750
    - require:
      - pkg: prosody-packages

{% for host, args in salt['pillar.get']('prosody:vhosts', {})|dictsort -%}
/etc/prosody/conf.avail/{{ host }}.cfg.lua:
  file.managed:
    - source: salt://prosody/vhost.cfg.lua.jinja
    - template: jinja
    - user: root
    - group: prosody
    - mode: 640
    - context:
      host: {{ host }}
      ssl_key: {{ args['ssl_key'] }}
      ssl_cert: {{ args['ssl_cert'] }}
    - require:
      - file: /etc/prosody/conf.avail

/etc/prosody/conf.d/{{ host }}.cfg.lua:
  file.symlink:
    - target: /etc/prosody/conf.avail/{{ host }}.cfg.lua
    - watch_in:
      - service: prosody
{% endfor %}
