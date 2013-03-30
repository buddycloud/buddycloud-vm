class buddycloud::server ($domain, $shared_secret) {

  ##### Dependencies #####

  include nodejs
  include git
  include gcc

  package { "coffee-script": 
    ensure => present,
    provider => npm,
    require => Class["nodejs"],
    before => Exec["npm-buddycloud::server"]
  }

  package { "libicu-dev": 
    ensure => present,
    before => Exec["npm-buddycloud::server"]
  }

  package { "libpq-dev": 
    ensure => present,
    before => Exec["npm-buddycloud::server"]
  }

  ##### Installation #####

  vcsrepo { "/opt/buddycloud/server":
    ensure => present,
    provider => git,
    source => "https://github.com/buddycloud/buddycloud-server.git",
    require => Class["git"],
    before => Exec["npm-buddycloud::server"]
  }

  exec { "npm-buddycloud::server":
    command => "npm install .",
    cwd => "/opt/buddycloud/server",
    logoutput => on_failure,
    require => [Class["nodejs"], Class["gcc"]],
    before => Exec["cake-buddycloud::server"]
  }

  exec { "cake-buddycloud::server":
    command => "cake build",
    cwd => "/opt/buddycloud/server",
    logoutput => on_failure
  }

  ##### Configuration #####

  file { "/opt/buddycloud/server/config.js": 
    ensure => present,
    content => template("buddycloud/config.server.js.erb"),
    require => Vcsrepo["/opt/buddycloud/server"],
    before => Service["buddycloud-server"]
  }

  ##### Database Setup #####

  include postgresql::server

  postgresql::db { "buddycloud_server":
    user => "buddycloud_server",
    password => "${shared_secret}",
    before => Exec["psql-install.sql"]
  }

  exec { "psql-install.sql":
    command => "echo ${shared_secret} | cat - install.sql | psql -h localhost -U buddycloud_server -d buddycloud_server",
    provider => shell,
    cwd => "/opt/buddycloud/server/postgres",
    user => "postgres",
    logoutput => on_failure,
    require => Vcsrepo["/opt/buddycloud/server"],
    before => Exec["psql-upgrade-1.sql"]
  }

  exec { "psql-upgrade-1.sql":
    command => "echo ${shared_secret} | cat - upgrade-1.sql | psql -h localhost -U buddycloud_server -d buddycloud_server",
    provider => shell,
    cwd => "/opt/buddycloud/server/postgres",
    user => "postgres",
    logoutput => on_failure,
    require => Vcsrepo["/opt/buddycloud/server"]
  }

  ##### Startup #####

  file { "/etc/init/buddycloud-server.conf":
    ensure  => present,
    source  => "puppet:///modules/buddycloud/buddycloud-server.conf",
    before => Service["buddycloud-server"]
  }

  service { "buddycloud-server":
    ensure => running,
    require => [
      Exec["npm-buddycloud::server"],
      Exec["cake-buddycloud::server"],
      Exec["psql-upgrade-1.sql"]
    ],
    subscribe => Service["prosody"]
  }

}