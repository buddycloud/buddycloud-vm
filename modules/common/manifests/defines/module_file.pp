# common/manifests/defines/modules_file.pp -- use a modules_dir to store module
# specific files
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

# Usage:
# modules_file { "module/file":
#     source => "puppet:///...",
#     mode   => 644,   # default
#     owner  => root,  # default
#     group  => 0,     # default
# }
define module_file (
	$source,
	$ensure = present,
	$alias = undef,
	$mode = 0644, $owner = root, $group = 0
    )
{
    include common::moduledir
    file {
        "${common::moduledir::module_dir_path}/${name}":
            source => $source,
            ensure => $ensure,
            alias => $alias,
            mode => $mode, owner => $owner, group => $group;
    }
}

# alias for compatibility
define modules_file (
    $source,
	  $ensure = present,
	  $alias = undef,
    $mode = 0644, $owner = root, $group = 0
  )
{
  module_file { $name:
      source => $source,
      ensure => $ensure,
      alias => $alias,
      mode => $mode, owner => $owner, group => $group
      }
}
