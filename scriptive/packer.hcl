packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

CI/Generic/Scripted/AMI/Packer/ubuntu-ami.pkr.hcl

source "amazon-ebs" "ubuntu" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  region        = var.aws_region

  ami_name        = var.ami_name
  ami_description = "Ubuntu AMI created using Packer inside an EC2 instance"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt update"
    ]
  }
}

CI/Generic/Scripted/AMI/Packer/variables.pkr.hcl

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_name" {
  default = "packer-ubuntu-instance-image"
}
