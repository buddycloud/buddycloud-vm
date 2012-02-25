class buddycloud::xmpp {
    package { "prosody": ensure => installed }
    service { "prosody": ensure => running, require => Package['prosody']}
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
}
