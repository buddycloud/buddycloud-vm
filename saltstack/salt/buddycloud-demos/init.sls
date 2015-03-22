robotnik-demo:
  git.latest:
    - name: https://github.com/robotnic/buddycloud-xmpp-website.git
    - rev: buddycloud-move
    - target: /usr/share/nginx/html/
    - force: true
    - require:
        - pkg: git

