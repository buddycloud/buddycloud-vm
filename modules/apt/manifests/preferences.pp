define apt::preferences(
  $pin,
  $priority,
  $ensure=present,
  $package=$name,
) {

  $fname = regsubst($name, '\.| ', '-', 'G')

  # apt support preferences.d since version >= 0.7.22
  if versioncmp($::apt_version, '0.7.22') >= 0 {
    file {"/etc/apt/preferences.d/${fname}":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('apt/preferences.erb'),
      before  => Exec['apt-get_update'],
      notify  => Exec['apt-get_update'],
    }
  } else {
    concat::fragment {$fname:
      ensure  => $ensure,
      target  => '/etc/apt/preferences',
      content => template('apt/preferences.erb'),
    }
  }

}
