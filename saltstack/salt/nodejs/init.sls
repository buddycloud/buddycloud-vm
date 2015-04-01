iojs-get-tarball:
  file.managed:
    - name: /tmp/{{ filename }}
    - source: https://iojs.org/dist/v1.6.3/iojs-v1.6.3-linux-x64.tar.gz
    - source_hash: shasum256=cf0b5308dc27118c607bc36478f99ab0be0cc5b13e80e4696fda0189810f00af

iojs-extract-tarball:
  cmd.run:
    - name: tar xf /tmp/{{ filename }}
    - cwd: /tmp
    - require:
      - file: iojs-get-tarball
    - watch:
      - file: iojs-get-tarball

iojs-move-files:
  cmd.run:
    - name: /usr/bin/rsync -ap ./ /usr/local/iojs
    - cwd: /tmp/iojs-v1.6.3-linux-x64

iojs-doc-directory:
  file.directory:
    - name: /usr/local/iojs/share/docs
    - group: root
    - makedirs: True
    - mode: 755
    - user: root

iojs-make-bom:
  cmd.run:
    - name: tar tf /tmp/{{ filename }} > /usr/local/iojs/share/docs/files
    - cwd: /tmp
    - require:
      - file: iojs-get-tarball
    - watch:
      - file: iojs-get-tarball

iojs-remove-nodejs:
  cmd.run:
    - name: rm /usr/bin/nodejs

iojs-link-iojs:
  file.symlink:
    - name: /usr/local/bin/iojs
    - target: /usr/local/iojs/bin/iojs

iojs-link-nodejs:
  file.symlink:
    - name: /usr/bin/nodejs
    - target: /usr/local/iojs/bin/iojs

iojs-link-node:
  file.symlink:
    - name: /usr/local/bin/node
    - target: /usr/local/iojs/bin/node

iojs-link-npm:
  file.symlink:
    - name: /usr/local/bin/npm
    - target: /usr/local/iojs/bin/npm

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
