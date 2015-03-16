# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Forward ports
  config.vm.network :forwarded_port, guest: 5222,  host: 5222   # XMPP-client
  config.vm.network :forwarded_port, guest: 5269,  host: 5269   # XMPP-S2S
  config.vm.network :forwarded_port, guest: 80,    host: 10080  # Webclient
  config.vm.network :forwarded_port, guest: 10123, host: 10123  # HTTP API

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../../vbnfs", "/vbnfs"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true
  
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.name = "buddycloud-dev-machine"
  end

  # Masterless salt configuration
  config.vm.synced_folder "saltstack/salt",   "/srv/salt"
  config.vm.synced_folder "saltstack/pillar", "/srv/pillar"

  # Use all the defaults:
  config.vm.provision :salt do |salt|
    
    salt.minion_config = "saltstack/configs/minion.conf"
    salt.run_highstate = true
    salt.colorize = true
    salt.log_level = "info"
    salt.verbose = true
    # I also prefer to install from git so I can specify a version.
    salt.install_type = "git"
    salt.install_args = "v2015.2" 
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.
end
