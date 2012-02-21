class apt::params {

  $manage_preferences = $apt_manage_preferences ? {
     ""      => true,
     default => $apt_manage_preferences,
  }

  $manage_sourceslist = $apt_manage_sourceslist ? {
    ""      => true,
    default => $apt_manage_sourceslist,
  }

}
