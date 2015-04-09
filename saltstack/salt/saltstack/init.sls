/srv/salt_upstream:
  file.directory:
    - mode: '0755'
    - user: 'root'
    - group: 'root'

/srv/salt_local:
  file.directory:
    - mode: '0755'
    - user: 'root'
    - group: 'root'

/usr/local/sbin/update-buddycloud-salt:
  file.managed:
    - source:
      - salt://saltstack/update-buddycloud-salt
    - mode: '0755'
    - user: 'root'
    - group: 'root'

