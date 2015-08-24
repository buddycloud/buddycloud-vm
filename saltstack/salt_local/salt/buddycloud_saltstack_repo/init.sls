buddycloud_saltstack_repo_checkout:
  git.latest:
    - name: https://github.com/buddycloud/saltstack.git
    - rev: master
    - target: /srv/buddycloud_saltstack_repo
    - force_reset: true
