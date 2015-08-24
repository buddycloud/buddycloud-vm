nodesource:
  pkgrepo.managed:
    - humanname: NodeJs Repository
    - name: deb https://deb.nodesource.com/node012 trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/nodesource.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - keyserver: keys.gnupg.net

install-node012:
  pkg.latest:
    - name: nodejs
