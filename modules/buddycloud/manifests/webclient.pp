class buddycloud::webclient ($domain, $api_root) {

  ##### Dependencies #####

  include git

  ##### Installation #####

  vcsrepo { "/opt/buddycloud/webclient":
    ensure => present,
    provider => git,
    source => "https://github.com/buddycloud/webclient.git",
    require => Class["git"]
  }

  ##### Configuration #####

  file { "/opt/buddycloud/webclient/config.js": 
    ensure => present,
    replace => true,
    content => template("buddycloud/config.webclient.js.erb"),
    require => Vcsrepo["/opt/buddycloud/webclient"]
  }

}