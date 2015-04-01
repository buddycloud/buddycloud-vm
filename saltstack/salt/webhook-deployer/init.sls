#
# Todo add deploy code
#

webhook-firewall:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dport: 8080
    - proto: tcp
    - save: True


