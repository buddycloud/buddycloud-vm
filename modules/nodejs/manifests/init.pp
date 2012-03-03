class nodejs {

    apt::key{"node":
        content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ES/EY5AEEAOZl+6Cv7b0fOnXLj8lt1cZiNQHIuOkGRJaMUdvXdrSbtQ4v9GiMWFoFj+9g
dFN9EjD9JKoXjJb/e/Q9P21uOi0/YmlOfkqWvqm1qsyBXTXTrGx1mghtALPSw0bvYoWZ3aZJ
3c9VPT5sCdv9IYw6X/+4Z0HoQGvxymbfvRKH3J/xABEBAAG0EkxhdW5jaHBhZCBjaHJpc2xl
YYi2BBMBAgAgBQJL8RjkAhsDBgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQuTFqe8eRexLB
rAQAk9ux3R+k38+dY0f8p3B+0UESy/jNFL/S+t6Fdpw/2qMV1EZohAgJXUw/axmTdr1gKUoy
GDtE13gebKGy+zqtzsIVo44V0ztC3Z7Kbd9bbiW+wMo7RT4yyi6kURMyE68RrqGbkenZveU6
o2Urq4LW6bfn5fDLVeYQ5GNsrNdSS1k=
=9f3N
-----END PGP PUBLIC KEY BLOCK-----',
        stage => 'apt',
    }

    apt::sources_list{"node":
        ensure  => present,
        content => "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu oneiric main",
        require => [Apt::Key['node']],
        stage   => 'apt',
    }

    package{"nodejs": ensure => installed, require => Apt::Sources_list['node'], stage => 'apt'}
    package{"nodejs-dev": ensure => installed, require => Apt::Sources_list['node'], stage => 'apt'}
    package{"npm": ensure => installed, require => Apt::Sources_list['node'], stage => 'apt'}

}

