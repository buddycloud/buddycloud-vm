import "common"

stage {
    "apt": before => Stage["packages"];
    "packages": before => Stage["main"];
    "post": require => Stage["main"];
}

class finalize {
    exec => '/usr/local/sbin/update-buddycloud'
}

node default {
    package { "apparmor": ensure => purged }
    package { "avahi-daemon": ensure => installed }
    service { "avahi-daemon": ensure => running, require => Package["avahi-daemon"], }
    buddycloud::server { "buddycloud":
        domain => 'buddycloud.local',
        externalip => "$ipaddress_eth0",
    }
    class {'finalize': stage => 'post',}
}

