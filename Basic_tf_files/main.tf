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
