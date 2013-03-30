# buddycloud Vagrant Box

This set of scripts allows you to automatically build a virtual machine with
the complete [buddycloud](http://www.buddycloud.com) stack installed, using
[Vagrant](http://www.vagrantup.com/) and [Puppet](http://puppetlabs.com/).
Its main use is as a development environment for buddycloud hackers.

## Installation & Usage

First, make sure you have Vagrant (>= 1.1.x), Puppet and
[VirtualBox](https://www.virtualbox.org/) installed. If you use
Ubuntu, run the following:

    sudo apt-get install virtualbox virtualbox-dkms puppet rubygems
    sudo gem install vagrant

Then, change to the buddycloud-vm directory and run:

    vagrant up

This builds and starts up the virtual machine. The first time you do this,
Vagrant will download a slimmed-down Ubuntu 12.04 base image as basis for
the VM, so it may take some time. If everything is done, you can immediately
start to use the buddycloud instance locally by pointing your browser at
`http://localhost:10080`. For other mapped ports, see the `Vagrantfile` in
the base directory.

Every `vagrant up` run updates all buddycloud components to the latest
development version. You can explicitly update and restart the VM with
`vagrant reload`.

To log into the VM with a shell, connect to it with

    vagrant ssh

For more information, see the [Vagrant documentation](http://docs.vagrantup.com/v1/docs/commands.html).