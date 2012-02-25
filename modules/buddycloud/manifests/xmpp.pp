class buddycloud::xmpp {
    apt::key {"prosody":
        ensure => present,
        source => 'http://prosody.im/files/prosody-debian-packages.key',
    }
    apt::sources_list{"prosody":
        ensure  => present,
        content => "deb http://ppa.launchpad.net/prosody-dev/ppa/ubuntu lucid main\ndeb http://packages.prosody.im/debian maverick main",
        require => Apt::Key['prosody'],
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
