# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Forward ports
  config.vm.network :forwarded_port, guest: 8080,  host: 8080   # non-ssl-website
  config.vm.network :forwarded_port, guest: 5222,  host: 5222   # XMPP-client
  config.vm.network :forwarded_port, guest: 5269,  host: 5269   # XMPP-S2S
  config.vm.network :forwarded_port, guest: 80,    host: 10080  # Webclient
  config.vm.network :forwarded_port, guest: 10123, host: 10123  # HTTP API
  
  # ssh <username>@127.0.0.1:2222
  config.ssh.forward_agent = true

  # Provision the box with a masterless salt configuration
  config.vm.synced_folder "saltstack/salt",    "/srv/salt"
  config.vm.synced_folder "saltstack/pillar",  "/srv/pillar"
  config.vm.synced_folder "buddycloud-webapp", "/opt/buddycloud-webapp"
  config.vm.provision :salt do |salt|
    salt.minion_config = "saltstack/configs/minion.conf"
    salt.run_highstate = true
    salt.colorize = true
    salt.log_level = "info"
    salt.verbose = true
    salt.install_type = "git"
    salt.install_args = "v2015.2" 
  end

  # configure for virtualbox
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.name = "buddycloud-dev-machine"
  end
  
  # configure for Google Compute
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
