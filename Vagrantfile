# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "buddycloud"
  config.vm.box_url = "buddycloud.box"
  # config.vm.boot_mode = :gui
  # config.vm.network "33.33.33.10"
  config.vm.forward_port 80,8080
  config.vm.forward_port 443,8443
  config.vm.forward_port 5553,53
  config.vm.forward_port 5269,5269
  config.vm.forward_port 5222,5222

  # config.vm.share_folder "v-data", "/vagrant_data", "../data"
  config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "manifests"
     puppet.module_path    = "modules"
     puppet.manifest_file  = "site.pp"
  end

end
