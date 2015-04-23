robotnik-demo:
  git.latest:
    - name: https://github.com/robotnic/buddycloud-xmpp-website.git
    - rev: buddycloud-move
    - target: /usr/share/nginx/html/
    - force_reset: true
    - force: true
    - require:
        - pkg: git

demo-install-npm:
  cmd.run:
    - name: npm i .
    - cwd: /usr/share/nginx/html
    - creates: /usr/share/nginx/html/node_modules
    - require:
       - git: robotnik-demo

demo-install-grunt:
  cmd.run:
    - name: grunt --force
    - cwd: /usr/share/nginx/html
    - creates: /usr/share/nginx/html/index.html
    - require:
      - cmd: demo-install-bower

demo-install-bower:
  cmd.run:
    - name: bower install --allow-root --force-latest
    - cwd: /usr/share/nginx/html
    - creates: build/vendor
    - requires:
      - cmd: demo-install-npm

wifi-chat-dependencies:
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

wifi-chat-npm-packages:
  npm.installed:
    - names:
      - grunt-cli

wifi-chat-git-checkout:
  git.latest:
    - name: https://github.com/project-isizwe/wifi-chat.git
    - rev: master
    - target: /opt/wifi-chat
    - force_reset: true
    - force: true

wifi-chat-install:
  cmd.run:
    - name: npm i --development .
    - cwd: /opt/wifi-chat
    - require:
       - git: wifi-chat-git-checkout

/opt/wifi-chat/config.production.js:
  file.managed:
    - source: salt://wifi-chat/config.production.js.template
    - user: root
    - group: root
    - mode: 0755
    - template: jinja

/etc/init/wifi-chat.conf:
  file.managed:
    - source: salt://wifi-chat/upstart-script.template
    - user: root
    - group: root
    - mode: 0755
    - template: jinja
  service.running:
    - name: wifi-chat
    - enable: True
    - full_restart: True
    - watch:
      - file: /opt/wifi-chat/*
