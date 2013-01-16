class lua-dbi {
    file { "/opt/lua-dbi":
        ensure  => directory,
        recurse => true,
        source  => 'puppet:///lua-dbi/deb',
    }
    exec { "apt-get install libpq5 && dpkg -i /opt/lua-dbi/*.deb":
        unless  => 'dpkg -l | grep lua-dbi',
        require => File['/opt/lua-dbi'],
    }
}

