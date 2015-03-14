foundation:
  pkg.installed:
    - pkgs:
      - vim
      - tmux
      - htop
      - tree
      - htop
      - git
  cmd.run:
     - name: dpkg-reconfigure locales
  locale.system:
     - name: en_US.UTF-8
  environ.setenv:
     - name: LANG
     - value: en_US.UTF-8
