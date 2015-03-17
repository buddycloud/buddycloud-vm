buddycloud-pusher:
  pkg:
    - installed
    - sources:
      - buddycloud-pusher: http://downloads.buddycloud.com/packages/debian/nightly/buddycloud-pusher/buddycloud-pusher-0.1+dev20140122.git.4a94d18/buddycloud-pusher_0.1+dev20140122.git.4a94d18-1_all.deb

/usr/share/buddycloud-pusher/configuration.properties:
  file.managed:
    - source: salt://buddycloud-pusher/configuration.properties.template
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/usr/share/buddycloud-pusher/log4j.properties:
  file.managed:
    - source: salt://buddycloud-pusher/log4j.properties
    - user: root
    - group: root
    - mode: 0644
