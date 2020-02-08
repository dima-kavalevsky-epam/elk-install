# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["VAGRANT_DETECTED_OS"] = ENV["VAGRANT_DETECTED_OS"].to_s + " cygwin"

$script_centos7 = <<SCRIPT
# sudo yum install epel-release
# sudo yum -y update
## Enable password ssh authentication for Vagrant VM
sudo sed -i -e 's/^PasswordAuthentication no/PasswordAuthentication yes/' -e 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo /sbin/service sshd restart
SCRIPT

$script_update_hosts = <<SCRIPT
cat  > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.56.21 elkserver
192.168.56.22 elkclient
EOF
SCRIPT

$ansible = <<SCRIPT
# yum install -y epel-release
sudo yum -y update
sudo yum install -y python-pip mc wget git net-tools
# pip install -U pip
# pip install -U ansible
sudo yum install ansible -y
# sudo yum install java-1.8.0-openjdk -y
# java -version
SCRIPT

$infoScript = <<SCRIPT
  echo 'IP-addresses of the vm ...'
  ip add
SCRIPT


sh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"
  config.vm.boot_timeout = 100
  config.ssh.forward_agent = true
  config.vm.define "elkserver" do |elkserver_config|
    elkserver_config.vm.box = "centos/7"
    elkserver_config.vm.network :forwarded_port, guest: 80, host: 80, auto_correct: true # httpd
    elkserver_config.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true 
    elkserver_config.vm.network :forwarded_port, guest: 8740, host: 8740, auto_correct: true # Debug
    elkserver_config.vm.network :forwarded_port, guest: 5601, host: 5601, auto_correct: true # Kibana
    elkserver_config.vm.hostname = "elkserver"
    elkserver_config.vm.provision "shell", inline: $script_centos7
    elkserver_config.vm.provision "shell", inline: $script_update_hosts
    elkserver_config.vm.provision :shell, inline: $ansible 
    elkserver_config.vm.provision "shell", inline: $infoScript, run: "always"
    # elkserver_config.vm.provision :shell, path: "./scripts/stage_env.sh", :args => shared_dir, :privileged => true
    elkserver_config.vm.network "private_network", ip: "192.168.56.21"
    elkserver_config.vm.synced_folder "ansible-elk/", "/workspace", id: "workspace-root",owner: "vagrant", group: "vagrant",mount_options: ["dmode=775,fmode=664"]
    elkserver_config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        if ENV["HOSTNAME"] == 'EPBYMINW0868' 
              vb.customize ['modifyvm', :id, '--memory', '4048']
        else
              vb.customize ['modifyvm', :id, '--memory', '2024']
        end   
        vb.customize ["modifyvm", :id, "--cpus", "1"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]        
    end
  end 
#=====================================
   config.vm.define "elkclient" do |elkclient_config|
    elkclient_config.vm.box = "centos/7"
    elkclient_config.ssh.insert_key = false
    elkclient_config.vm.hostname = "elkclient"
    elkclient_config.vm.provision "shell", inline: $script_update_hosts
    elkclient_config.vm.provision "shell", inline: $script_centos7
    elkclient_config.vm.synced_folder "ansible-elk/", "/workspace", id: "workspace-root", owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=664"]
    elkclient_config.vm.network "private_network", ip: "192.168.56.22"
    elkclient_config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.customize ['modifyvm', :id, '--memory', '512']
        vb.customize ["modifyvm", :id, "--cpus", "1"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end  
  end
end
