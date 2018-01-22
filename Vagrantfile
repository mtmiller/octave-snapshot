# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 6
  end
  config.vm.provision :shell, path: "guest-bootstrap.sh", args: "--with-qt=4"
end
