########### Security Group

resource "aws_security_group" "k8s-security" {
  vpc_id = "${aws_vpc.k8s-vpc-main.id}"
  name = "k8s-security"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
     # Allow the network range for best practise
      cidr_blocks = ["0.0.0.0/0"] 

  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
     # Allow the network range for best practise
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
     # Allow the network range for best practise
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "k8s-security"
  }
}

