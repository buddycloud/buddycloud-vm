class buddycloud {
    file {"/usr/local/sbin/update-buddycloud":
        source => "puppet:///modules/buddycloud/update-buddycloud",
        ensure => present,
        mode   => 0755,
    }
    file {"/srv/http/":
        ensure => directory,
        mode   => 0755,
    }
    file{"/etc/buddycloud/":
        ensure => directory,
        mode   => 0755,
    }
}

define buddycloud::server(
    $domain,
    $externalip
) {
    include apt
    include buddycloud::database
    include buddycloud
    buddycloud::dns::domain{"$domain":
        externalip => "$externalip",
    }
    buddycloud::cert{"$domain": }
    buddycloud::web::vhost{"$domain": }
    buddycloud::web::config{"$domain": }
    buddycloud::xmpp::config{"$domain": }
    notify {"secret": message => "serversecret: $serversecret"}
}

define buddycloud::cert() {
    $domain = $name
    exec { "openssl-key-$domain":
        command => "/usr/bin/openssl req -new -x509 -days 3650 -nodes -out /etc/apache2/$domain.cert -keyout /etc/apache2/$domain.key -batch -subj /CN=$domain",
        creates => "/etc/apache2/$domain.key",
    }
}

