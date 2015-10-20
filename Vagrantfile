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
  config.vm.network :forwarded_port, guest: 5222, host: 5222, protocol: 'tcp' # XMPP-client
  config.vm.network :forwarded_port, guest: 5269, host: 5269, protocol: 'tcp' # XMPP-S2S
  config.vm.network :forwarded_port, guest: 5432, host: 5432, protocol: 'tcp' # Postgresql
  config.vm.network :forwarded_port, guest: 443,  host: 8080, protocol: 'tcp' # website

  # Provision the box with a masterless salt configuration
  config.vm.synced_folder "saltstack/salt_local",               "/srv/salt_local"
  config.vm.synced_folder "saltstack/vagrant_salt_bootstrap",   "/srv/vagrant_salt_bootstrap"
  config.vm.provision :shell, :inline => "sudo /srv/vagrant_salt_bootstrap/bootstrap.sh"

  # configure for virtualbox
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.gui    = false
    virtualbox.memory = 2048
    virtualbox.cpus   = 1
    virtualbox.name   = "buddycloud-vm"
  end

  # Libvirt
  config.vm.provider "libvirt" do |lv|
    lv.memory = 2048
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
