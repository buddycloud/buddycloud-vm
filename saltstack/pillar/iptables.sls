default to DROP:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP

firewall:
  install: True
  enabled: True
  strict: True
  services:
    ssh:
      block_nomatch: True
      ips_allow:
        - 0.0.0.0/0

