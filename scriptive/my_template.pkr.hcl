packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
source "amazon-ebs" "otms_salary_api" {
  region          = "eu-north-1"
  source_ami      = "ami-05d3e0186c058c4dd" # Ubuntu 22.04
  instance_type   = "t2.medium"
  ssh_username    = "ubuntu"
  ami_name        = "otms_salary-api-{{timestamp}}"
  # Tag
  tags = {
    Name = "otms_salary-api-server"
  }
}
build {
  sources = ["source.amazon-ebs.otms_salary_api"]
  provisioner "shell" {
    inline = [
      # System updates
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      # Install Maven
      "sudo apt install maven -y -",
      
 
      # Insatll make
      "sudo apt install make -y",
      # Clone Jaav repo
      "https://github.com/OT-MICROSERVICES/salary-api.git",
      # set environment variable
      "export NODE_OPTIONS=--openssl-legacy-provider",
      # Enter Frontend repo
      "cd salary-api",
      # Install dependencies and build the app
      "make build",      
    ]
  }
}
