class buddycloud::xmpp::repository {
    include lua-dbi
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
}

class buddycloud::xmpp {
    class{"buddycloud::xmpp::repository": stage => 'apt'}
    package { "liblua5.1-sql-postgres-2": ensure => installed }
    package { "lua-zlib": ensure => installed, require => Apt::Sources_list['prosody'] }
    package{"libicu-dev": ensure => installed}
    package{"build-essential": ensure => installed}
    package{"node-stringprep":
        provider => 'npm',
        require  => [Package['npm'], Package['libicu-dev'], Package['build-essential']],
    }

}

define buddycloud::xmpp::config(
    $admin = false
) {
    class{"buddycloud::xmpp": stage => 'packages'}
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
    }
    file {'/usr/lib/prosody/modules/mod_register.lua':
        source  => "puppet:///buddycloud/mod_register.lua",
        ensure  => present,
        require => Package['prosody'],
    }
    package { "prosody": ensure => installed }
    service { "prosody":
        hasrestart => false, #broken
        ensure     => running,
        require    => [Package['prosody'], File['/etc/prosody/prosody.cfg.lua'], File['/usr/lib/prosody/modules/mod_register.lua']],
    }
}

define buddycloud::xmpp::component() {
    class{"nodejs": stage => 'apt'}

    file {'/etc/buddycloud/component-config.js':
        ensure  => present,
        content => template("buddycloud/component-config.erb"),
    }
    file {'/etc/buddycloud-server': ensure => directory}
    file {'/etc/buddycloud-server/config.js':
        ensure => link,
        target => '/etc/buddycloud/component-config.js',
    }
    file {'/etc/init.d/buddycloud-component':
        ensure => present,
        mode   => 0755,
        source => "puppet:///buddycloud/init-buddycloud-component"
    }
}

