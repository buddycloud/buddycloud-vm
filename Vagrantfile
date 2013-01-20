# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.forward_port 5222, 5222   # XMPP
  config.vm.forward_port 9123, 19123  # HTTP API  
  config.vm.forward_port 80, 10080    # Webclient

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.module_path    = "modules"
     puppet.manifest_file  = "site.pp"
  end
end
