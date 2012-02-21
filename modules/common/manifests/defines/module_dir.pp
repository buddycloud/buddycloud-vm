# common/manifests/defines/modules_dir.pp -- create a default directory
# for storing module specific information
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

# Usage:
# include common::moduledir
# module_dir { ["common", "common/dir1", "common/dir2" ]: }
#
# You may refer to a file in module_dir by using :
# file { "${common::moduledir::module_dir_path}/somedir/somefile": }

define module_dir (
        $mode = 0644, $owner = root, $group = 0
    )
{
    include common::moduledir
    $dir = "${common::moduledir::module_dir_path}/${name}"
    if defined(File[$dir]) {
        debug("${dir} already defined")
    } else {
        file {
            $dir:
                source => [ "puppet:///modules/${name}/modules_dir", "puppet:///modules/common/empty"],
                checksum => mtime,
                # ignore the placeholder
                ignore => '.ignore',
                recurse => true, purge => true, force => true,
                mode => $mode, owner => $owner, group => $group;
        }
    }
}

# alias for compatibility
define modules_dir (
        $mode = 0644, $owner = root, $group = 0
    )
{
  module_dir { $name: mode => $mode, owner => $owner, group => $group }
}
