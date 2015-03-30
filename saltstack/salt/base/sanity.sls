foundation:
  pkg.installed:
    - pkgs:
      - language-pack-en
      - vim
      - tmux
      - htop
      - tree
      - htop
      - git
      - python-git
  cmd.run:
     - name: dpkg-reconfigure locales
en_US.UTF-8:
    locale.system
