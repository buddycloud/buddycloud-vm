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

