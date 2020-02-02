---------------------
Prerequisite   
---------------------
Linux server , Java 1.8 , Python 2.7 +, Ansible 2.7 , Ansible ssh keys configuration , Terraform v0.11.1,cloud accounts with required access 
to provision resources, Github Credentials

------------------------------------------
   Terraform Setup in Local Machine 
------------------------------------------

1. Define infrastructure as code to increase operator productivity and transparency.
2. Terraform provides an elegant user experience for operators to safely and predictably make changes to infrastructure.
3. Terraform Setup local machine like centos and ubuntu . 
 
curl -O https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip
echo $PATH /sbin:/bin:/usr/sbin:/usr/bin
unzip terraform_0.11.1_linux_amd64.zip -d /usr/bin/
terraform --version
Terraform v0.11.1
Your version of Terraform is out of date! The latest version
is 0.12.20. You can update by downloading from www.terraform.io/downloads.html

Part 2 

Create a Directory mkdir /opt/data/
Clone the Code from github and provide the Access key ID and Secret access key in terraform.tfvars file .
Run the below commands to create the private and public key in this path /opt/data/infra-code/ 
ssh-keygen  -f k8s-key 
chmod +x master-script.sh 
chmod +x  worker-script.sh

Put that public key k8s-key.pub  --> master-script.sh and worker-script.sh to access the server .

------------------------------------------
   Ansible Setup in Local Machine 
------------------------------------------

sudo yum install epel-release -y

sudo  yum install python ansible  -y

sudo yum install wget PyYAML libtomcrypt libtommath libyaml python-babel python-httplib2 python-jinja2 python-keyczar python-markupsafe python-pyasn1  python-six pytho2-crypto python2-ecdsa python2-paramiko sshpass -y

sudo yum update -y

sudo echo "ansible  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

######## Add ansible user to connect the client to ansible server
sudo useradd ansible
sudo su - ansible
sudo mkdir -p /home/ansible/.ssh
cd  /home/ansible/.ssh
echo "k8s-key.pub copy " >>  authorized_keys
yum -y install epel-repo
yum -y update
yum -y install ansible
ansible --version

-------------------------------------------------------
   Infra provisioning for jenkins and kuberntes Cluster  
-------------------------------------------------------
Infra create two server creatre jenkins&K8s master server setup and one K8s worker.

cd /opt/data/k8s-ansible/

ansible-playbook infra-terraform.yaml

The get the public ip to run this command /opt/data/infra-code/apply.txt and put that ip in hosts file whic is locate in /opt/data/k8s-ansible/hosts.

ansible-playbook k8s-dependence.yaml

ansible-playbook k8s-master.yaml

ansible-playbook k8s-worker.yaml

ansible-playbook k8s-service.yaml

-------------------------------------------------------
   jenkins Job setup 
-------------------------------------------------------

Install Jenkins Plugin as per your job requirement 

Login to Jenkins UI using your admin account, and go to “Manage Jenkins” -> Manage Plugins -> Click on “Installed” Tab -> From here, 
search for “github plugin” in the filter

Click on “New” to create a new jenkins job. Select “Pipeline Project” as type as shown below. Name: Dev App Build. Type: Pipeline Project

Click on GitHub project provide the https://github.com/chauhanudham/interview.git/  and Build Triggers --> click on GitHub hook trigger for GITScm polling 

Pipeline --> provide the groovy script .

jenkins Job and github webhook integration .

Github --> chauhanudham/interview --> setting --> Webhooks --> addwebhook --> Payload UR(http://publicip:8080/github-webhook/) --> click on Just the push event.


