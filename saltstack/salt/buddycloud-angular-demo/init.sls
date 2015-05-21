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

buddycloud-angular-demo-checkout:
  git.latest:
    - name: https://github.com/robotnic/angular-xmpp.git
    - rev: master
    - target: /opt/buddycloud-angular-demo
    - force_reset: true
    - force: true

/opt/buddycloud-angular-demo:
  file.directory:
    - user: nobody
    - group: nogroup
    - mode: 755
    - recurse:
      - user
      - group

/var/log/buddycloud/buddycloud-angular-demo.log:
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

  pkg:
    - installed
    - sources:
      - buddycloud-angular-demo: http://downloads.buddycloud.com/packages/debian/nightly/webclient/webclient_latest.deb

/etc/nginx/sites-enabled/buddycloud-angular-demo.conf:
  file.managed:
    - source: salt://buddycloud-angular-demo/buddycloud-angular-demo.js.jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - template: jinja
