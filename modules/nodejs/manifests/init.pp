class nodejs {

    apt::key{"npm":
        content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ETnD1WwEEAKJWE70uR4T/FmbPeCN9h5FiaVPj+wizjBJ/DhjgxXylCbMm8ed8v9zNAAPb
bcFPjuqJJ1MXMsPgRryOLTBvJ4ZaZcvvx3/y3rEGfcT1+whZRS51gUSVB2u+gYipR3TaO3vN
ZQOHp637Pr2DeWtfRaKI9JahCLVKZiisBVtsuP6HABEBAAG0HkxhdW5jaHBhZCBQUEEgZm9y
IEdpYXMgS2F5IExlZYi4BBMBAgAiBQJOcPVbAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIX
gAAKCRADfiqe/UsnAnd0A/0U6ZFhszCTKegaVBjaqYoxy3P218D4rQLQOkPssFkg4XUEZ9w6
+t6B13groYxdH5ttabp5w1A90clvuQe/G4OavkL3xPNCAxiF22LJGOZVS8cliNc3A0zd2F+a
29qyZhXrzSOSmqgVpPoNas7QVgyVuAsrvINEKGBq210kFITsVw==
=i7D9
-----END PGP PUBLIC KEY BLOCK-----'
    }

    apt::sources_list{"npm":
        ensure  => present,
        content => "deb http://ppa.launchpad.net/gias-kay-lee/npm/ubuntu oneiric main",
        require => [Apt::Key['npm']],
    }

    package{"nodejs": ensure => installed, require => Apt::Sources_list['npm']}
    package{"nodejs-dev": ensure => installed, require => Apt::Sources_list['npm']}
    package{"npm": ensure => installed, require => Apt::Sources_list['npm']}

}

