input-policy:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP

output-policy:
  iptables.set_policy:
    - chain: OUTPUT
    - policy: ACCEPT

forward-policy:
  iptables.set_policy:
    - chain: FORWARD
    - policy: ACCEPT

firewall:
  install: True
  enabled: True
  strict: True
  services:
    ssh:
      block_nomatch: True
      ips_allow:
        - 0.0.0.0/0

