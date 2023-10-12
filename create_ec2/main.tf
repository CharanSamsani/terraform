provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "charan"{
  instance_type = "t2.micro"
  ami = "ami-0c55b159cbfafe1f0"
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
