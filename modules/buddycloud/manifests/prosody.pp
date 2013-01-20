class buddycloud::prosody ($domain, $shared_secret) {

  include lua-dbi
  include postgresql::server

  postgresql::db { "buddycloud_prosody" :
    user => "buddycloud_prosody",
    password => "${shared_secret}",
    before => Service["prosody"]
  }

  package { "prosody":
    ensure => present,
    require => Class["lua-dbi"],
    before => File["/etc/prosody/prosody.cfg.lua"]
  }

  file { "/etc/prosody/prosody.cfg.lua":
    ensure  => present,
    content => template("buddycloud/prosody.cfg.lua.erb"),
    notify => Service["prosody"]
  }

  service { "prosody":
    ensure => running,

    # As the installation of the Prosody package automatically 
    # starts the service without Puppet knowing, Prosody normally
    # wouldn't normally be restarted as Puppet would run "service
    # prosody restart". This means that our configuration file,
    # which is installed after the package, wouldn't be picked up.
    # Thus, we need to tell Puppet to always try a restart (which
    # also works if the service is not running).
    start => "service prosody restart"
  }

}