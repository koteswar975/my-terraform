resource "aws_instance" "web_apps" {
  ami                    = "ami-0217a85e28e625474"
  instance_type          = "t2.micro";  subnet_id              = local.pub_sub_ids[0]
  vpc_security_group_ids =[aws_security_group.web_sg.id]
  key_name               = "koti keypair"
  user_data              = "${file("scripts/apache.sh")}"

  tags = {
    Name        = "Web App"
    Environment = terraform.workspace
  }
}

1