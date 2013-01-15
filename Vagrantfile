# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "buddycloud.box"

  config.vm.forward_port 53, 5553
  config.vm.forward_port 5269, 5269
  config.vm.forward_port 5222, 5222
  config.vm.forward_port 8080, 80
  config.vm.forward_port 8443, 443

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.module_path    = "modules"
     puppet.manifest_file  = "site.pp"
  end
end
