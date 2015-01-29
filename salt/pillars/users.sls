users:
  simon:
    state: present
    fullname: Simon Tennant
    shell: /bin/bash
    home: /home/simon
    uid: 4000 
    groups:
      - wheel
    pubkey: ssh-dss AAAAB3NzaC1kc3MAAACBAKKFx7hGR3xi1T9OwhLfIs0synlZB2/jvPxrJYL29E5OG2jE1zPfKuouMain9ppk/6+soRskufFV33sbxrr6jsLxLitXVQdsrFXI3HyR6CpIsyHrHpPeUl1XGYQ4WKp/kzQVkP/p0JDY4MtF3vpgFNdKEEBXdtdgcIXw326iE3i7AAAAFQD8RNEYBX8Xtl2ua7XNFp7sh7j5VQAAAIBoPpACJsBlVaFc9mz/L/7hlp6xvvEPSnqyxLUuY7vEDn0xJN1miIqTmlXOw8m7vp+rBLMNIqT3A7lJcizYNmkQlhrSxOrVyRSCtUDL3uqsXd/xLpDq2GbpkUm9tonsQ6uc9Wc8CHhF7PidVyCNgiyGCj5XjACxSp5B9fNNZ5mn0QAAAIBeovAF4Mbj1VC8wnOsYyCj23/STPYo3ZnLPl83uWoJmnyMf/i12RIrJLvuot3T6BjSvCdHsHh3bqHnXHSSf/s7HJD0q/9jGaUv1D1u7HfNIyAIsl+7OarN7SgiL6LB6iC5UD1uQBbmpbqpbpLFTxS7YAnywvC+UG7uEoucLALOeQ== simon@bunker
  ubuntu:
    state: absent
    purge: True
