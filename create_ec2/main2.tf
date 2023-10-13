provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "fullscale" {
    ami = "ami-0c42696027a8ede58"
    instance_type = "t2.micro"
    key_name = "key.ssh"
    tags = {
      Name = "fullscale"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                yum install java-1.8* -y
                yum install wget -y
                sudo cd /opt
                sudo wget -P /opt https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz
                sudo tar -xvzf apache-tomcat-7.0.92.tar.gz
                sudo rm -rf apache-tomcat-7.0.92.tar.gz
                sudo apache-tomcat-7.0.92 tomcat
                EOF
}
