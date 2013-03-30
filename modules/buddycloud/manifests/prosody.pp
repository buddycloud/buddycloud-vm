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
    require => Class["lua-dbi"]
  }

  # Self-signed TLS certificate generation

  exec { "openssl_genrsa":
    command => "openssl genrsa -out /etc/prosody/certs/${domain}.key",
    require => Package["prosody"],
    before => Exec["openssl_req"]
  }

  exec { "openssl_req":
    command => "openssl req -new \
    -subj '/C=DE/ST=Berlin/L=Berlin/O=IT/CN=${domain}.com' \
    -key /etc/prosody/certs/${domain}.key \
    -out /etc/prosody/certs/${domain}.csr",
    before => Exec["openssl_x509"]
  }  

  exec { "openssl_x509":
    command => "openssl x509 -req \
    -in /etc/prosody/certs/${domain}.csr \
    -signkey /etc/prosody/certs/${domain}.key \
    -out /etc/prosody/certs/${domain}.cert"
  }  

  # Configuration

  file { "/etc/prosody/prosody.cfg.lua":
    ensure  => present,
    content => template("buddycloud/prosody.cfg.lua.erb"),
    require => [
      Package["prosody"],
      Exec["openssl_x509"]
    ],
    notify => Service["prosody"]
  }


  service { "prosody":
    ensure => running,

    # The installation of the Prosody package automatically 
    # starts the service without Puppet knowing. Thus, Puppet only
    # runs "service prosody start" when the configuration file is
    # updated, which will do nothing; the configuration will never
    # be picked up. To work around this, well tell Puppet to always
    # use "service prosody restart", even if it thinks Prosody hasn't
    # been started yet. (This command also works if Prosody really
    # isn't running yet.)
    start => "service prosody restart"
  }

}
