######## Key Pair 
resource "aws_key_pair" "k8s-mykeypair" {
  key_name = "k8s-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

