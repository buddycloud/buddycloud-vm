class buddycloud::xmpp {
    apt::key {"prosody":
        ensure => present,
        source => 'http://prosody.im/files/prosody-debian-packages.key',
    }
    apt::key {"prosody-ppa":
        ensure => present,
        content => "-----BEGIN PGP PUBLIC KEY BLOCK-----\nVersion: SKS 1.0.10\n\nmI0ESejI7gEEAK3TQd9orDIBZYP7TpGNyfP1xhOK7ubQQS28YGXkQjKIYAQ67l9eNja3+P8t\nkfqstu9EPeGs8cwC0w+1vBLz/gDy12Yee3FA//lxNCJxER+DD5bL/N1YNJU5W/ePeOHhpk5N\naWmq/Tg2nM5NUf0TcW6SYqOzLILYWFx6HRKJ88KFABEBAAG0J0xhdW5jaHBhZCBQUEEgZm9y\nIFByb3NvZHkgSU0gRGV2ZWxvcGVyc4i2BBMBAgAgBQJJ6MjuAhsDBgsJCAcDAgQVAggDBBYC\nAwECHgECF4AACgkQqDGxck3uKwOjbAQAorqJ2x1KCkezsmJP7m7PPlBAaOiegp8TwSE8u/tA\nDvGMfP7ISoRX4lSkZLKNTkZ/1qs15CJrg3PE4gpNhGZh6q4Bj1n/DCAh3W+h5c082xcZXkCF\n2efgbSxJOvYeOdbY0il80SP8ql+nZ8oMiUMWyiE7wuKEPPD/2rK/ejxDdeA=\n=avQM\n-----END PGP PUBLIC KEY BLOCK-----",
    }
    apt::sources_list{"prosody":
        ensure  => present,
        content => "deb http://ppa.launchpad.net/prosody-dev/ppa/ubuntu lucid main\ndeb http://packages.prosody.im/debian maverick main",
        require => [Apt::Key['prosody'],Apt::Key['prosody-ppa']],
    }
    package { "prosody": ensure => installed }
    package { "liblua5.1-sql-postgres-2": ensure => installed }
    package { "liblua5.1-dbi0": ensure => installed, require => Apt::Sources_list['prosody'] }
    package { "lua-zlib": ensure => installed, require => Apt::Sources_list['prosody'] }
    service { "prosody":
        ensure => running,
        require => [Package['prosody'], Package['liblua5.1-sql-postgres-2'], Package['liblua5.1-dbi0']]
    }
}

define buddycloud::xmpp::config(
    $admin = false
) {
    include buddycloud::xmpp
    $domain = $name
    if (($admin == false) or ($admin == []) or ($admin == '')) {
        $iadmin = [ "admin@$domain" ]
    } else {
        if (is_string($admin)) {
            $iadmin = [ $admin ]
        } else {
            $iadmin = $admin
        }
    }
    file {'/etc/prosody/prosody.cfg.lua':
        content => template("buddycloud/prosody.cfg.erb"),
        ensure  => present,
        require => Package['prosody'],
        notify  => Service['prosody'],
    }
    file {'/usr/lib/prosody/modules/mod_register.lua':
        source  => "puppet:///buddycloud/mod_register.lua",
        ensure  => present,
        require => Package['prosody'],
        notify  => Service['prosody'],
    }
}

define buddycloud::xmpp::component() {
    file {'/etc/buddycloud/component-config.js':
        ensure  => present,
        content => template("buddycloud/component-config.erb"),
    }
}

