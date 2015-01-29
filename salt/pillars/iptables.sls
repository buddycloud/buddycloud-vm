firewall:
  install: True
  enabled: True
  strict: True
  services:
    ssh:
      block_nomatch: True
      ips_allow:
        - 0.0.0.0/0
