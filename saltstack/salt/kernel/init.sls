#
# Kernel options
#

# Swap usage if ram free < 5%
vm.swappiness:
  sysctl:
    - present
    - value: 5
