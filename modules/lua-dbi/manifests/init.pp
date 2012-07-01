class lua-dbi {
    file { "/opt/lua-dbi":
        ensure  => directory,
        recurse => true,
        source  => 'puppet:///lua-dbi/deb',
    }
    exec { "/usr/bin/apt-get install libpq5 && /usr/bin/dpkg -i /opt/lua-dbi/lua-dbi-common_0.5+svn78-4_all.deb /opt/lua-dbi/lua-dbi-postgresql_0.5+svn78-4_amd64.deb":
        unless  => '/usr/bin/dpkg -l | /bin/grep lua-dbi',
        require => File['/opt/lua-dbi'],
    }
}

