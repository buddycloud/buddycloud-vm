class buddycloud::dns {
    package { "bind9": ensure => latest }
    service { "bind9": ensure => running, require => Package["bind9"] }
    file { "/etc/resolv.conf":
        ensure  => present,
        content => 'nameserver 127.0.0.1',
    }
}

define buddycloud::dns::domain(
    $externalip
) {

    include buddycloud::dns

    $domain = $name

    file {"/etc/bind/named.$domain.conf":
        content => template("buddycloud/named.zone.conf.erb"),
        ensure  => present,
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    file {"/etc/bind/db.$domain":
        content => template("buddycloud/named-db.erb"),
        ensure  => present,
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    line { "include $domain":
        line    => "include \"/etc/bind/named.$domain.conf\";",
        file    => '/etc/bind/named.conf',
        ensure  => present,
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

}
