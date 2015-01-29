# Deps

software-properties-common:
  pkg.installed

apt-transport-https:
  pkg.installed

docker-ppa:
  pkgrepo.managed:
    - name: deb https://get.docker.io/ubuntu docker main
    - keyserver: hkp://keyserver.ubuntu.com:80
    - keyid: 36A1D7869245C8950F966E92D8576A8BA88D21E9
    - require:
      - pkg: software-properties-common
      - pkg: apt-transport-https

lxc-docker:
  pkg:
    - installed
  service.running:
    - name: docker
    - sig: /usr/bin/docker
    - require:
      - pkg: lxc-docker

python:
  pkg.installed

python-dev:
  pkg.installed:
    - require:
      - pkg: python

python-pip:
  pkg.installed:
    - require:
      - pkg: python-dev

docker-py:
  pip.installed:
    - reload_modules: True
    - require:
      - pkg: python-pip
