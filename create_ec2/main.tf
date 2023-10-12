provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "charan"{
  instance_type = "t2.micro"
  ami = "ami-0c42696027a8ede58"
  tags = {
    Name = "InstanceByTerraform"
  }
}

output "ip" {
  description = "public ip address"
  value = aws_instance.charan.public_ip
}

output "ec2_state" {
  description = "Instance state"
  value = aws_instance.charan.instance_state
}

output "ec2_type" {
  description = "Instance type"
  value = aws_instance.charan.instance_type
}
