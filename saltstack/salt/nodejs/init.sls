npm:
  pkg.installed

/usr/bin/node:
  file.symlink:
    - target: /usr/bin/nodejs

grunt-cli:
  npm.installed:
    - require:
      - pkg: npm

bower:
  npm.installed:
    - require:
      - pkg: npm
