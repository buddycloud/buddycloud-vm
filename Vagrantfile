# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "buddycloud.local"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forward_port, guest: 5222, host: 5222   # XMPP
  config.vm.network :forward_port, guest: 9123, host: 19123  # HTTP API
  config.vm.network :forward_port, guest: 80,   host: 10080  # Webclient

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.module_path    = "modules"
     puppet.manifest_file  = "site.pp"
  end

  # Work around https://github.com/mitchellh/vagrant/issues/516
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
  end
end
