class common::moduledir {
    # Use this variable to reference the base path. Thus you are safe from any
    # changes.
    $module_dir_path = '/var/lib/puppet/modules'

    # Module programmers can use /var/lib/puppet/modules/$modulename to save
    # module-local data, e.g. for constructing config files
    file{$module_dir_path:
        ensure => directory,
        source => "puppet:///modules/common/modules/",
        ignore => '.ignore',
        recurse => true, purge => true, force => true,
        mode => 0755, owner => root, group => 0;
    }
}
