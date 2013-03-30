import "./config"

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node default {

  class { "buddycloud":
    domain => "example.com"
  }

  class { "nginx":
    require => Class["buddycloud"]
  }

  nginx::resource::vhost { "localhost":
    ensure => enable,
    www_root => "/opt/buddycloud/webclient",
  }

  # There seems to be a bug in the puppetlabs/nginx module which seems
  # causes nginx not to be restarted after the vhost is added to its
  # configuration. We work around this problem by restarting nginx
  # manually.

  exec { "service nginx restart":
    require => Nginx::Resource::Vhost["localhost"],
    subscribe => Exec["rebuild-nginx-vhosts"]
  }
}

