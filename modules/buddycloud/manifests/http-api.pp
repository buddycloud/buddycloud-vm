class buddycloud::http-api ($domain) {

  ##### Dependencies #####

  include nodejs
  include git
  include gcc

  package { "libexpat-dev": 
    ensure => present,
    before => Exec["npm-buddycloud::http-api"]
  }

  package { "libxml2-dev": 
    ensure => present,
    before => Exec["npm-buddycloud::http-api"]
  }

  ##### Installation #####

  vcsrepo { "/opt/buddycloud/http-api":
    ensure => present,
    provider => git,
    source => "https://github.com/buddycloud/buddycloud-http-api.git",
    require => Class["git"],
    before => [
      Exec["npm-buddycloud::http-api"],
      File["/opt/buddycloud/http-api/config.js"]
    ]
  }

  exec { "npm-buddycloud::http-api":
    command => "npm install .",
    cwd => "/opt/buddycloud/http-api",
    logoutput => on_failure,
    require => [Class["nodejs"], Class["gcc"]]
  }

  ##### Configuration #####

  file { "/opt/buddycloud/http-api/config.js": 
    ensure => present,
    content => template("buddycloud/config.http-api.js.erb"),
    require => Vcsrepo["/opt/buddycloud/http-api"],
    notify => Service["buddycloud-http-api"]
  }

  ##### Startup #####

  file { "/etc/init/buddycloud-http-api.conf":
    ensure  => present,
    source  => "puppet:///modules/buddycloud/buddycloud-http-api.conf",
    before => Service["buddycloud-http-api"]
  }

  service { "buddycloud-http-api":
    ensure => running,
    require => Exec["npm-buddycloud::http-api"]
  }

}