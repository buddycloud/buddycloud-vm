wifi-chat-git-checkout:
  git.latest:
    - name: https://github.com/project-isizwe/wifi-chat.git
    - rev: master
    - target: /opt/wifi-chat
    - force_reset: true
    - force: true
    - require:
        - pkg: git

wifi-chat-install:
  cmd.run:
    - name: npm i --development .
    - cwd: /opt/wifi-chat
    - require:
       - git: wifi-chat-git-checkout

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




