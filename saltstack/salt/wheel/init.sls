wheel:
  group.present:
    - system: True

/etc/sudoers.d/wheel:
  file.managed:
    - user: root
    - group: root
    - mode: 640
    - contents: "%wheel     ALL=(ALL)     NOPASSWD: ALL\n"
    - require:
      - group: wheel
