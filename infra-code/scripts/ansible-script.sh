#!/bin/bash

######### Install Packages 

sudo yum install epel-release -y

sudo  yum install python ansible  -y        

sudo yum install wget PyYAML libtomcrypt libtommath libyaml python-babel python-httplib2 python-jinja2 python-keyczar python-markupsafe python-pyasn1  python-six pytho2-crypto python2-ecdsa python2-paramiko sshpass -y 

sudo yum update -y

######## Allow Ansible User to /etc/sudoers File
sudo su 
sudo echo "ansible  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

######## Add ansible user to connect the client to ansible server 
sudo useradd ansible 
sudo su - ansible
sudo mkdir -p /home/ansible/.ssh
cd  /home/ansible/.ssh 
echo "" >>  authorized_keys

####### Change the file Permission 
sudo chmod 755 /home/ansible/.ssh 
sudo chmod 600 authorized_keys
sudo chown -R ansible.ansible /home/ansible/.ssh
cd  /home/ansible/



