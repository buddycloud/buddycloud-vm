class buddycloud (
  $domain,
  $secret = "secret"
) {

  file { "/opt/buddycloud/":
    ensure => directory,
    mode   => 0755,
  }

  file { "/etc/buddycloud/":
    ensure => directory,
    mode   => 0755,
  }

  # Use the Node.js package from Chris Lea's Node.js PPA
  # so that we have the newest version. Due to a bug in
  # the puppetlabs/apt module, we need to explicitly call
  # "apt-get update" beforehand.

  exec { "buddycloud::apt_update":
    command => "apt-get update"
  }

  apt::ppa { "ppa:chris-lea/node.js":
    before => Class["nodejs"],
    require => Exec["buddycloud::apt_update"]
  }

  class { "buddycloud::prosody":
    domain => $domain,
    shared_secret => $secret
  }

  class { "buddycloud::server":
    domain => $domain,
    shared_secret => $secret
  }

  class { "buddycloud::http-api":
    domain => $domain
  }

  class { "buddycloud::webclient":
    domain => $domain,
    api_root => "http://localhost:9123"
  }

}