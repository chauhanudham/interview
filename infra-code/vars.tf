######### Variable Define

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "k8s-key"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "k8s-key.pub"
}
variable "INSTANCE_USERNAME" {
  default = "centos"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-0015b9ef68c77328d"
  }
}
