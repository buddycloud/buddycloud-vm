import "common"
import "./config"

stage {
    "apt": before => Stage["packages"];
    "packages": before => Stage["main"];
    "post": require => Stage["main"];
}

class finalize {
    exec{"finalize":
        command => '/usr/local/sbin/update-buddycloud',
        creates => '/srv/http/index.html',
    }
}

node default {
    package { "apparmor": ensure => purged }
    package { "avahi-daemon": ensure => installed }
    service { "avahi-daemon": ensure => running, require => Package["avahi-daemon"], }
    buddycloud::server { "buddycloud":
        domain => "$buddycloud_domain",
        externalip => "$buddycloud_ip",
    }
    class{'finalize': stage => 'post'}
}

