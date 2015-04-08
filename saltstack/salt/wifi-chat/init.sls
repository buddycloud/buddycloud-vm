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
    - source: salt://wifi-chat/upstart-script
    - user: root
    - group: root
    - mode: 0755
  service.running:
    - name: wifi-chat
    - enable: True
    - reload: True


