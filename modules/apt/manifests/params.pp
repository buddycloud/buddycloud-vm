class apt::params {

  $manage_preferences = $apt_manage_preferences ? {
    ''      => true,
    default => $apt_manage_preferences,
  }

  $manage_sourceslist = $apt_manage_sourceslist ? {
    ''      => true,
    default => $apt_manage_sourceslist,
  }

  $ignore_sourceslist = $apt_ignore_sourceslist ? {
    ''      => '.placeholder',
    default => $apt_ignore_sourceslist,
  }

  $keyring_package = $::lsbdistid ? {
    Debian => ['debian-keyring', 'debian-archive-keyring'],
    Ubuntu => 'ubuntu-keyring',
  }

  $clean_minutes  = $apt_clean_minutes ? {
    ''      => fqdn_rand(60),
    default => $apt_clean_minutes,
  }

  $clean_hours    = $apt_clean_hours ? {
    ''      => '0',
    default => $apt_clean_hours,
  }

  $clean_monthday_rand = fqdn_rand(28) + 1

  $clean_monthday = $apt_clean_mday ? {
    ''      => $clean_monthday_rand,
    default => $apt_clean_mday,
  }
}
