debconf-utils:
  pkg.installed

oracle-java7-installer:
  pkgrepo.managed:
    - ppa: webupd8team/java
  pkg.installed:
    - require:
      - pkgrepo: oracle-java7-installer
  debconf.set:
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
    - require_in:
      - pkg: oracle-java7-installer

