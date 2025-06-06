packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "ami_name" {
  type    = string
  default = "packer-ubuntu-instance-image"
}

source "amazon-ebs" "ubuntu" {
  region                  = var.aws_region
  instance_type           = "t2.micro"
  ssh_username            = "ubuntu"
  ami_name                = var.ami_name
  ami_description         = "Ubuntu AMI created using Packer inside an EC2 instance"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["951708948157"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y curl git"
    ]
  }
}
