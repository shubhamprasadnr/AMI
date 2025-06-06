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
  instance_type   = "t3.micro"
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
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",

      # Install Java 17
      "sudo apt install openjdk-17-jdk -y",
      "java -version",  # Verify Java installation
      
      # Install required packages
      "sudo apt install make -y",
      "sudo apt install maven -y",

      # Clone the project repository
      "git clone https://github.com/OT-MICROSERVICES/salary-api.git",

     
    ]
  }
}
