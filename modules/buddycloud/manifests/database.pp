class buddycloud::database {
    package { "postgresql": ensure => installed }
    service { "postgresql": ensure => running, require => Package["postgresql"] }
    exec { "postgres-start":
        command => "/etc/init.d/postgres start",
        require => Service["postgresql"],
        unless  => "/bin/ps aux | /bin/grep [p]ostgres"
    }
    exec { "buddycloud-db-user-create":
        command => "/usr/bin/psql -c \"CREATE USER buddycloud WITH PASSWORD '$serversecret'\"",
        user    => "postgres",
        require => Exec["postgres-start"],
        unless  => "/usr/bin/psql -c \"select rolname from pg_roles;\" | /bin/grep buddycloud",
    }
    exec { "buddycloud-db-user":
        command => "/usr/bin/psql -c \"ALTER ROLE buddycloud WITH PASSWORD '$serversecret'\"",
        user    => "postgres",
        require => Exec["buddycloud-db-user-create"],
    }
    exec { "buddycloud-prosody-db":
        command => "/usr/bin/createdb --owner buddycloud --encoding UTF8 buddycloud-prosody -T template0",
        user    => "postgres",
        unless  => '/usr/bin/psql -c "select * from pg_tablespace;" | /bin/grep buddycloud-prosody',
        require => Exec["buddycloud-db-user"],
    }
    exec { "buddycloud-server-db":
        command => "/usr/bin/createdb --owner buddycloud --encoding UTF8 buddycloud-server -T template0",
        user    => "postgres",
        unless  => '/usr/bin/psql -c "select * from pg_tablespace;" | /bin/grep buddycloud-server',
        require => Exec["buddycloud-db-user"],
    }
    file { "/root/.pgpass.conf":
        ensure  => present,
        mode    => 0600,
        content => "127.0.0.1:5432:buddycloud-server:buddycloud:$serversecret",
    }
}

