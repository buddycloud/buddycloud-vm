install-buddyclould-http-api-dependencies:
  pkg.installed:
    - pkgs:
      - git
      - git-core
      - libicu-dev
      - libexpat-dev
      - build-essential
      - libexpat1-dev
      - libssl-dev
      - build-essential
      - g++

buddycloud-http-api-git-checkout:
  git.latest:
    - name: https://github.com/buddycloud/buddycloud-http-api.git
    - rev: develop
    - target: /opt/buddycloud-http-api
    - force_reset: true
    - force: true

/opt/buddycloud-http-api:
  file.directory:
    - user: nobody
    - group: nogroup
    - mode: 755
    - recurse:
      - user
      - group

/var/log/buddycloud/buddycloud-http-api.log:
  file.managed:
    - user: nobody
    - group: nogroup
    - mode: 644

buddycloud-http-api-install:
  cmd.run:
    - name: npm i --development .
    - cwd: /opt/buddycloud-http-api
    - require:
       - git: buddycloud-http-api-git-checkout

/opt/buddycloud-http-api/config.js:
  file.managed:
    - source: salt://buddycloud-http-api/config.js.template
    - template: jinja

/etc/logrotate.d/buddycloud-http-api:
  file.managed:
    - source: salt://buddycloud-http-api/logrotate
    - user: root
    - group: root

/etc/init/buddycloud-http-api.conf:
  file.managed:
    - source: salt://buddycloud-http-api/upstart-script
    - user: root
    - group: root
    - mode: 0755
  service.running:
    - name: buddycloud-http-api
    - enable: True
    - force_reload: True
    - full_restart: True
    - watch:
      - file: /opt/buddycloud-http-api/*

xmpp-ftw-firewall:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 3000
    - proto: tcp
    - save: True

