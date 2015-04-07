buddycloud-http-api-git-checkout:
  git.latest:
    - name: https://github.com/buddycloud/buddycloud-http-api.git
    - rev: master
    - target: /opt/buddycloud-http-api
    - force_reset: true
    - force: true
    - require:
        - pkg: git

buddycloud-http-api-install:
  cmd.run:
    - name: npm i --development .
    - cwd: /opt/buddycloud-http-api
    - require:
       - git: buddycloud-http-api-git-checkout

/etc/init/buddycloud-http-api.conf:
  file.managed:
    - source: salt://buddycloud-http-api/upstart-script
    - user: root
    - group: root
    - mode: 0755
  service.running:
    - name: buddycloud-http-api
    - enable: True
    - reload: True




