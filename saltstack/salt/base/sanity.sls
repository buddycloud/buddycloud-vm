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

fix-locale:
  cmd.run:
     - name: localedef -i en_US -f UTF-8 en_US.UTF-8

en_US.UTF-8:
    locale.system
