###############################################
# SecureTheCloud – AWS EC2 Module
###############################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  iam_instance_profile = var.instance_profile

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = false

  root_block_device {
    encrypted   = true
    kms_key_id  = var.kms_key_id
    volume_size = 20
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y htop curl unzip
  EOF

  tags = {
    Name = var.name
  }
}
