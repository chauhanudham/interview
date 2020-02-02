data "template_file" "shell-script" {
  template = "${file("scripts/ansible-script.sh")}"
  vars {
   REGION = "${var.AWS_REGION}"
  }
}
data "template_cloudinit_config" "cloudinit-example" {

  gzip = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.shell-script.rendered}"
  }
  
}

