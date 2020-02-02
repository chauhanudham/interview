############# Internet VPC
resource "aws_vpc" "k8s-vpc-main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "k8s-vpc-main"
    }
}

############# Subnets For Public
resource "aws_subnet" "k8s-public-subnet-1" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags {
        Name = "k8s-public-subnet-1"
    }
}
resource "aws_subnet" "k8s-public-subnet-2" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"

    tags {
        Name = "k8s-public-subnet-2"
    }
}

############# Subnets For Private

resource "aws_subnet" "k8s-private-subnet-1" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"

    tags {
        Name = "k8s-private-subnet-1"
    }
}
resource "aws_subnet" "k8s-private-subnet-2" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"

    tags {
        Name = "k8s-private-subnet-2"
    }
}

#############  Internet GW For Public Subnet
resource "aws_internet_gateway" "k8s-vpc-main-gw" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"

    tags {
        Name = "k8s-vpc-main"
    }
}

#############  Route tables For Public Subnet
resource "aws_route_table" "k8s-public-subnet" {
    vpc_id = "${aws_vpc.k8s-vpc-main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.k8s-vpc-main-gw.id}"
    }

    tags {
        Name = "k8s-public-subnet-1"
    }
}

#############  Route associations public
resource "aws_route_table_association" "k8s-public-subnet-1-a" {
    subnet_id = "${aws_subnet.k8s-public-subnet-1.id}"
    route_table_id = "${aws_route_table.k8s-public-subnet.id}"
}
resource "aws_route_table_association" "k8s-public-subnet-2-a" {
    subnet_id = "${aws_subnet.k8s-public-subnet-2.id}"
    route_table_id = "${aws_route_table.k8s-public-subnet.id}"
}


