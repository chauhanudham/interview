----------------------------------------
     Prerequisite for this Project 
----------------------------------------
Linux Server , Java 1.8 , Python 2.7 +, Ansible 2.7 , Ansible ssh keys configuration , Terraform v0.11.1, AWS Cloud Accounts with required access 
to provision resources, Github Credentials. 

------------------------------------------
   Terraform Setup in Local Machine 
------------------------------------------

1. Define infrastructure as code to increase operator productivity and transparency.
2. Terraform provides an elegant user experience for operators to safely and predictably make changes to infrastructure.
3. Terraform Setup in local machine like centos and ubuntu . 
4. Run the below command with user root as well as sudo user .

$ curl -O https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip
$ echo $PATH /sbin:/bin:/usr/sbin:/usr/bin
$ unzip terraform_0.11.1_linux_amd64.zip -d /usr/bin/
$ terraform --version

Part 2 
1. Create a Directory and clone the code from github .
$ mkdir /opt/data/
$ cd /opt/data/
$ git clone https://github.com/chauhanudham/interview.git

2. After Clone the Code from github and provide the Access key ID and Secret access key in terraform.tfvars file .
3. Run the below commands to create the private and public key in this path /opt/data/infra-code/ 
$ ssh-keygen  -f k8s-key 
$ chmod +x master-script.sh 
$ chmod +x  worker-script.sh

3. Put that public key "k8s-key.pub" in --> master-script.sh and worker-script.sh to access the Jenkins & K8s Servers .

------------------------------------------
   Ansible Setup in Local Machine 
------------------------------------------

$ yum install epel-release -y

$  yum install python ansible  -y

$ yum install wget PyYAML libtomcrypt libtommath libyaml python-babel python-httplib2 python-jinja2 python-keyczar python-markupsafe python-pyasn1  python-six pytho2-crypto python2-ecdsa python2-paramiko sshpass -y

$ echo "ansible  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

$ useradd ansible

$ su - ansible

$ mkdir -p /home/ansible/.ssh

$ cd /home/ansible/.ssh

$ echo "k8s-key.pub copy " >>  authorized_keys

$ ansible --version

-------------------------------------------------------
   Infra provisioning for jenkins & kuberntes Cluster  
-------------------------------------------------------
1. Infra create two server creatre jenkins & K8s master and K8s worker setup.

$ cd /opt/data/k8s-ansible/

$ ansible-playbook infra-terraform.yaml

2. After the infra provisioning create the Kubeadm kuberntes cluster with automatic connect worker . 

3. The get the public ip run this command  cat /opt/data/infra-code/apply.txt and put that ip in hosts file which is locate 
in this path /opt/data/k8s-ansible/hosts.

4. Local ansible machine connect kK8s master and K8s worker server then run the playbook one by one , your cluster will be ready with in 5 min .  

$ cd /opt/data/k8s-ansible/

$ ansible-playbook k8s-dependence.yaml

$ ansible-playbook k8s-master.yaml

$ ansible-playbook k8s-worker.yaml

$ ansible-playbook k8s-service.yaml

-------------------------------------------------------
   Jenkins Job setup and K8s cluster deployment 
-------------------------------------------------------

1. Install Jenkins Plugin as per your job requirement 

2. Login to Jenkins UI using your admin account, and go to “Manage Jenkins” -> Manage Plugins -> Click on “Installed” Tab -> From here, 
search for “github plugin” in the filter

3. Click on “New” to create a new jenkins job. Select “Pipeline Project” as type as shown below. Name: Dev App Build. Type: Pipeline Project

4. Click on GitHub project provide the https://github.com/chauhanudham/interview.git/  and Build Triggers --> click on GitHub hook trigger for GITScm polling 

Pipeline --> paste the groovy script or Jenkinsfile .

5. Jenkins Job and github webhook integration go to Github --> chauhanudham/interview --> setting --> Webhooks --> addwebhook --> Payload UR(http://publicip:8080/github-webhook/) --> click on Just the push event.
