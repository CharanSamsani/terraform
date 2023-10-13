provider "aws" {
  region = "ap-south-1"
}


data "aws_vpc" "existing_vpc" {
  id = "vpc-0f7311c7b9ca7167c" 
}


data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = "subnet-097b805fc0a91c2e5" 
}


data "aws_security_group" "existing_security_group" {
  name = "launch-wizard-12" 
}


resource "aws_instance" "fullscale" {
  ami           = "ami-0c42696027a8ede58"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet.id
  key_name      = "KEY"
  associate_public_ip_address = true
  security_groups = [data.aws_security_group.existing_security_group.id]
  tags = {
    Name = "fullscale"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install java-1.8* -y
    sudo yum install wget -y
    sudo cd /opt
    sudo wget -P /opt https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz
    sudo tar -xvzf /opt/apache-tomcat-7.0.92.tar.gz -C /opt
    sudo rm -rf /opt/apache-tomcat-7.0.92.tar.gz
    sudo mv /opt/apache-tomcat-7.0.92 /opt/tomcat
  EOF
}

