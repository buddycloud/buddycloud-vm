# == Class: apt::clean
#
# Create a cronjob which will run "apt-get clean" once a month.
#
# === Variables
#
#  *$minutes*: cronjob minutes  - default uses fqdn_rand(), range 0 to 59
#  *$hours*:   cronjob hours    - default to 0
#  *$monthday*:    cronjob monthday - default uses fqdn_rand(), range 1 to 29
#
class apt::clean (
  $minutes = $apt::params::clean_minutes,
  $hours = $apt::params::clean_hours,
  $monthday = $apt::params::clean_monthday,
) {
  cron {'cleanup APT cache - prevents diskfull':
    ensure   => present,
    command  => 'apt-get clean',
    hour     => $hours,
    minute   => $minutes,
    monthday => $monthday,
  }
}
