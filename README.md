# ELK stack 'Tech talk'
======================

A vagrant box that provisions Oracle software automatically, using Vagrant, an Oracle Linux box and a shell script.

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

## Getting started
1. Clone this repository `git clone https://github.com/oracle/vagrant-boxes`
2. Change into the desired software folder
3. Follow the README.md instructions inside the folder

## Building an ELK Stack with Vagrant and Ansible

This is the source code to along with the blog article [ELK-Stack-with-Vagrant-and-Ansible](http://xplordat.com/2017/12/12/elk-stack-with-vagrant-and-ansible/)

* Make sure that the host has sufficient CPU & RAM to build 7 vms as this one does.
* You can adjust the memory requirements in 'Vagrantfile'.

1. Generate two VM's by vagrant tool 
```sh
vagrant ssh-config
vagrant up 
```

2. Log in to ELKserver server and prepare to run ansible playbooks.

```sh
vagrant ssh elkserver
export LANG="en_EN.UTF-8"
alias mc='LANG=en_EN.UTF-8 mc'

cd /workspace/
sed -i 's/host-01/elkserver/' hosts
sed -i 's/host-02/elkclient/' hosts
ssh-keygen 

sudo sed -i -e 's/^PasswordAuthentication no/PasswordAuthentication yes/' -e 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo /sbin/service sshd restart
sudo systemctl restart sshd

ssh-copy-id vagrant@elkserver
ssh-copy-id vagrant@elkclient
## The default Passwor vagrant
ansible -m ping all -i hosts
```

3. Run ansible playbook to install and configure ElasticSearch, Logtsash, Kibana, Nginx and Curator tools

```sh
cd /workspace/
ansible-playbook -v -i hosts install/elk.yml 
# -extra-vars "ansible_ssh_user=vagrant ansible_ssh_pass=vagrant"
```

4. Check ELK stack successful installation.

- Navigate to [Kibana dashboard over Nginx on server](http://192.168.56.21:80) and login with admin/admin permissions to verify successful installation.
- Check availability  SSL Certificate key at http://192.168.56.21:8080/beat-forwarder.key for Filebeat

```sh
curl -O http://192.168.56.21:8080/beat-forwarder.key
```


5. Run ansible playbook to setup clients.

```sh
cd /workspace/
ansible-playbook -i hosts install/elk_client.yml --extra-vars 'elk_server=192.168.56.21'
```
