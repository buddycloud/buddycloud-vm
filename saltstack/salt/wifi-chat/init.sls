wifi-chat:
  git.latest:
    - name: https://github.com/project-isizwe/wifi-chat.git
    - rev: master
    - target: /opt/buddycloud-webapp
    - force_reset: true
    - force: true
    - require:
        - pkg: git

demo-install-npm:
  cmd.run:
    - name: npm i .
    - cwd: /opt/buddycloud-webapp
    - creates: /usr/share/nginx/html/node_modules
    - require:
       - git: wifi-chat

