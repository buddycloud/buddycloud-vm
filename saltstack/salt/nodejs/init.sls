npm:
  pkg.installed

grunt-cli:
  npm.installed:
    - require:
      - pkg: npm

bower:
  npm.installed:
    - require:
      - pkg: npm
