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
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN9XqbphSESDLhYcQB0TaL6L827t3xSUvaaV9Ksf+qErmHdWfDOPx91mXtqCRIFW4444/z0JUC5SabK/6TCVVaLCAzabEMOMzojG7QDwtxCgS16IjJWETyZEfZo3m/OTVNVJD/XL3n4+ACU0IvQKteLOGM+MKdiAr00jxKBDlkS3DEBzPSaVi4Er9SBMdNIl6FhseikOz9zTg2zDBl/Z+3ORmdlyuJ7H9WscMJQSpYdDjNHxWvsNBpzBUNvuGTaeq6WCNRECiWRVpu+c3jwB+1e2yDgttGitZbZeZnyV4Ffetf7iu8VFynltrOdcJgAhlSCaKFyVkwXFTJx8lQKa7l root@ip-10-0-1-24" >>  authorized_keys

####### Change the file Permission 
sudo chmod 755 /home/ansible/.ssh 
sudo chmod 600 authorized_keys
sudo chown -R ansible.ansible /home/ansible/.ssh
cd  /home/ansible/

####### Jenkins Setup 

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install java  jenkins git  -y
sleep 3
sudo systemctl start jenkins 
sudo  systemctl enable  jenkins

sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


