class syslog {
    package { "rsyslogd": ensure => installed }
    service { "rsyslogd": ensure => running, require => Package["rsyslogd"] }
    file {"/etc/rsyslog.d/10-udp.conf":
        ensure  => present,
        content => "\$ModLoad imudp\n\$UDPServerRun 514",
        require => Package["rsyslogd"],
    }
    file {"/etc/rsyslog.d/10-tcp.conf":
        ensure  => present,
        content => "\$ModLoad imtcp\n\$InputTCPServerRun 514",
        require => Package["rsyslogd"],
    }
}

