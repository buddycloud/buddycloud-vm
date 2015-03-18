users:
  ubuntu:
    state: absent
    purge: True
  simon:
    state: present
    fullname: Simon Tennant
    shell: /bin/bash
    home: /home/simon
    uid: 4000 
    groups:
      - wheel
    pubkey: ssh-dss AAAAB3NzaC1kc3MAAACBAKKFx7hGR3xi1T9OwhLfIs0synlZB2/jvPxrJYL29E5OG2jE1zPfKuouMain9ppk/6+soRskufFV33sbxrr6jsLxLitXVQdsrFXI3HyR6CpIsyHrHpPeUl1XGYQ4WKp/kzQVkP/p0JDY4MtF3vpgFNdKEEBXdtdgcIXw326iE3i7AAAAFQD8RNEYBX8Xtl2ua7XNFp7sh7j5VQAAAIBoPpACJsBlVaFc9mz/L/7hlp6xvvEPSnqyxLUuY7vEDn0xJN1miIqTmlXOw8m7vp+rBLMNIqT3A7lJcizYNmkQlhrSxOrVyRSCtUDL3uqsXd/xLpDq2GbpkUm9tonsQ6uc9Wc8CHhF7PidVyCNgiyGCj5XjACxSp5B9fNNZ5mn0QAAAIBeovAF4Mbj1VC8wnOsYyCj23/STPYo3ZnLPl83uWoJmnyMf/i12RIrJLvuot3T6BjSvCdHsHh3bqHnXHSSf/s7HJD0q/9jGaUv1D1u7HfNIyAIsl+7OarN7SgiL6LB6iC5UD1uQBbmpbqpbpLFTxS7YAnywvC+UG7uEoucLALOeQ== simon@bunker
users:
  jaredh:
    state: present
    fullname: Jared Honey
    shell: /bin/bash
    home: /home/jaredh
    uid: 4001
    groups:
      - wheel
    pubkey: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAtDIMohSq2fVSMbv7ZGc48180qEljuPW5hS1qckSUIaw3q8BnD/iI6l7v5laO4NGkTNuOpDhH6Y/Q62nl0r4s1KFezeyCjiSpeVivBhS1JVZIfoRBYj0Ds8IHADaejKUya2ZgJtG00xCL+Wz+93RPRKeeZHGba2jQe9exPp9SbDK5VJ4VmtctT/0dwpohFnc3AT2O0A8MMWSdE/5jkyxtHSzT97tm47wqnloInUe5e5Lo7L5BM8wK/1zrAKpCdrXGKvnJNLbZy1l7o0wfO1bfud1KPGHnywRp2OKp/6zvC+ELrWQNYML2ktQY02Xs/YOO39Mzkhvv1ZUh5qn0AYoJx1hJS03gDbAM1YwaXExWpExXVzIHtYqPCI9TYdGz3Q5p14jN77KsyTD0h/j3fkN6/kxtS/dbfgTBIWzBeou4mFltMIibN17jjwfeb/Zi0f0pDBpiZ0SvCtIlqBXGSEkjsLtY/rNrLekh/nmpUVNfd2ZInXQR46qQges6xKQUcsPuqdLpxe+8U2bylVRMpuQhqrCY7hg7uAt5dy1V6gnPSpbXdJP+xXNPONQIDwjmay2dmIAXB0AfYbJhU3uzePvOi9TsW2aBFpejnVBPiRg3EjKDJMDO15yUKUx6HqWZhcRBnfxOxBCg3JmmxJYFajGFEZvlUhoUxZU6WjiWVN+WK4M= 
users:
  lloyd:
    state: present
    fullname: Lloyd Watkin
    shell: /bin/bash
    home: /home/lloyd
    uid: 4002
    groups:
      - wheel
    pubkey: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc6kFQ20ciODsqAg+eyebTF0C9i3sNT7ucuduq6qH7X0BYVkpuVV4FCbGFkqjMkVSI8njwnWI0dmXE5MzonLs/tPYW8/xC5aM+zBKblsf1NC6tLKEoyqgKH9KaahRfqnAEE3oqkUoE6G6R9nb1+J9jKMoTiLSg/yjBAUoq7co5dXRtfQU2IBZu/X54JKf3Olo2VVAyke57ddjnDcW0VU/og4cnOOkgbQ8FlXcKW3vdxqKWzNr7i5/6T5Ehny/SH3/Mr8xElg7U41T9H3TS+fblVwKdKutXNE91jwaKa+7nKz0mJWGnnDDgqn7XXHTn0lS1UcAHmsHzAJQBgYTNNST9 lloyd@evilprofessor.co.uk


