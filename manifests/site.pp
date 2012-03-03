import "common"

stage {
    "apt": before => Stage["packages"];
    "packages": before => Stage["main"];
    "post": after => Stage["main"];
}

node default {
    package { "apparmor": ensure => purged }
    package { "avahi-daemon": ensure => installed }
    service { "avahi-daemon": ensure => running, require => Package["avahi-daemon"], }
    buddycloud::server { "buddycloud":
        domain => 'buddycloud.local',
        externalip => "$ipaddress_eth0",
    }
}

