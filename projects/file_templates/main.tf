data "template_file" "init" {
  template = "${file("${path.module}/files/shell-template.sh")}"
  vars = {
    app_name    = "foo"
    aws_region  = "us-west-2"
    environment = "fantasyland"
  }
}

resource "local_file" "shell" {
  content  = data.template_file.init.rendered
  filename = "${path.module}/out/init.sh"
}
