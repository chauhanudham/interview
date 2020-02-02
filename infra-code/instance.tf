########## k8s-master
resource "aws_instance" "k8s-master" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.medium"
  user_data = "${file("master-script.sh")}"
  count = 1
    tags {
        Name = "k8s-master-1"
  }

  # the VPC subnet
  subnet_id = "${aws_subnet.k8s-public-subnet-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.k8s-security.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.k8s-mykeypair.key_name}"

  # user data
 #user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"

}

########## k8s-worker 

resource "aws_instance" "k8s-worker" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.medium"
  user_data = "${file("worker-script.sh")}"
  count = 1
    tags {
        Name = "k8s-worker-1"
  }

  # the VPC subnet
  subnet_id = "${aws_subnet.k8s-public-subnet-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.k8s-security.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.k8s-mykeypair.key_name}"

  # user data
  #user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"

}



