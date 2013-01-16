class buddycloud::xmpp {
    include lua-dbi
    package { "libicu-dev": ensure => installed}
    package { "build-essential": ensure => installed}
    package { "node-stringprep":
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

