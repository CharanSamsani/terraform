provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "fullscale_terraform" {
  name        = "fullscale_terraform"
  description = "SecurityGroup with defined ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fullscale" {
  ami           = "ami-0c42696027a8ede58"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mysubnet.id
  key_name      = "KEY"
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

