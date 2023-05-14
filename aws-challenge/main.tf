resource "aws_key_pair" "citadel-key" {
  key_name   = "citadel"
  public_key = file("/root/terraform-challenges/project-citadel/.ssh/ec2-connect-key.pub")
}

resource "aws_eip" "eip" {
  vpc = true
  instance = aws_instance.citadel.id
  provisioner "local-exec" {
    command = "echo ${aws_eip.eip.public_dns} > /root/citadel_public_dns.txt"
  }
}

resource "aws_instance" "citadel" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.citadel-key.key_name
  user_data     = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install nginx -y
    sudo systemctl start nginx
  EOF
}

resource "aws_eip_association" "my_eip_association" {
  instance_id   = aws_instance.citadel.id
  allocation_id = aws_eip.eip.id
}


variable "ami"{
 default = "ami-06178cf087598769c"
}


variable "instance_type"{
 default = "m5.large"
}


variable "region"{
 default = "eu-west-2"
}



