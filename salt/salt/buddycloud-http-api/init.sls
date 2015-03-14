api-foundation:
  pkg.installed:
    - pkgs:
      - software-properties-common
      - python-software-properties
      - libicu-dev
      - nodejs
      - wget

buddycloud-http-api:
  pkg:
    - installed
    - sources:
      - buddycloud-server-java: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-http-api/buddycloud-http-api_latest.deb

/usr/share/buddycloud-http-api/config.js:
  file.managed:
    - source: salt://buddycloud-http-api/config.js
    - user: root
    - group: root
    - mode: 644
