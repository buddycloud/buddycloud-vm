# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.host_name = "buddycloud-vm.dev"
  config.ssh.forward_agent = true
  # Resolve "stdin: is not a tty" errors
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Forward ports
  config.vm.network :forwarded_port, guest: 53,   host: 53   # hosted nameserver
  config.vm.network :forwarded_port, guest: 80,   host: 8080 # website
  config.vm.network :forwarded_port, guest: 5222, host: 5222 # XMPP-client
  config.vm.network :forwarded_port, guest: 5269, host: 5269 # XMPP-S2S
  config.vm.network :forwarded_port, guest: 5432, host: 5432 # Postgresql

  # Provision the box with a masterless salt configuration
  config.vm.synced_folder "saltstack/config",                    "/etc/salt"
  config.vm.synced_folder "saltstack/salt_local",                "/srv/salt_local"
  # Saltstack needs python-git to work so we pre-install it
  config.vm.provision :shell, :inline => "sudo apt-get update -qq -y"
  config.vm.provision :shell, :inline => "sudo apt-get install python-git -qq -y"
  config.vm.provision :salt do |salt|
    # configure the master
    salt.install_master = true
    salt.master_config  = "saltstack/config/master"
    salt.master_key     = "saltstack/config/key/master.pem"
    salt.master_pub     = "saltstack/config/key/master.pub"
    # configure the minon
    salt.minion_config  = "saltstack/config/minion"
    salt.minion_key     = "saltstack/config/key/buddycloud-vm.dev.pem"
    salt.minion_pub     = "saltstack/config/key/buddycloud-vm.dev.pub"
    salt.seed_master = { 
      "buddycloud-vm.dev" => "saltstack/config/key/buddycloud-vm.dev.pub" 
    } 
    # other settings
    salt.always_install = true
    salt.log_level      = "error"
    salt.install_type   = "git"
    salt.install_args   = "v2015.5"
    salt.run_highstate  = false
    salt.colorize       = true
    salt.verbose        = true
  end
  # Now tell Saltstack to do it's thing
  config.vm.provision :shell, :inline => "sudo restart salt-master && sleep 10 && sudo restart salt-minion && sleep 10"
  config.vm.provision :shell, :inline => "sudo salt '*' state.highstate -l debug"  

  # configure for virtualbox
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
    v.name = "buddycloud-vm"
  end

  # Libvirt
  config.vm.provider "libvirt" do |lv|
    lv.memory = 1024
  end

  # Google Compute
  config.vm.provider :google do |google|
    google.google_project_id = "hallowed-coww-638"
    google.google_client_email = "user@domain.com"
    google.google_key_location = "~/.ssh/google_compute_engine.private_key"
    google.zone = "europe-west1-d"
    google.zone_config "europe-west1-d" do |zone1d|
      zone1d.name = "testing-vagrant"
      zone1d.image = "debian-7-wheezy-v20150127"
      zone1d.machine_type = "n1-standard-4"
      zone1d.zone = "europe-west1-d"
      zone1d.metadata = {'custom' => 'metadata', 'testing' => 'foobarbaz'}
      zone1d.tags = ['web', 'app1']
    end
  end

  # VMware Vcenter configuration
  config.vm.provider :vcenter do |vcenter|
    vcenter.hostname = 'my.vcenter.hostname'
    vcenter.username = 'myUsername'
    vcenter.password = 'myPassword'
    vcenter.folder_name = 'myFolderName'
    vcenter.datacenter_name = 'MyDatacenterName'
    vcenter.computer_name = 'MyHostOrCluster'
    vcenter.datastore_name = 'MyDatastore'
    vcenter.network_name = 'myNetworkName'
    vcenter.linked_clones = true
  end
end
