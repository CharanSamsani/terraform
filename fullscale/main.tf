resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
  }
}

resource "aws_route_table_association" "myrtassaciation" {
  subnet_id = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroutetable.id
}

resource "aws_security_group" "mysecgroup" {
  tags = {
    Name = "mysecgroup"
  }
  name = "mysecgroup"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TOMCAT"
    from_port = 8089
    to_port = 8089
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "sonarQube"
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbounds"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myinstance" {
  tags = {
    Name = "Terraform"
  }
  ami = "ami-0a5ac53f63249fba0"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.id
  subnet_id = aws_subnet.mysubnet.id
  vpc_security_group_ids = [aws_security_group.mysecgroup.id]

  connection {
    type = "ssh"
    host = self.public_dns
    user = var.username
    private_key = file("~/.ssh/id_rsa.pub")
  }

  provisioner "file" {
    source = "app.py"
    destination = "/home/ec2-user/app.py"
  }

  provisioner "remote-exec" {
    inline = [ 
      "echo 'Hello from Charan'",
      "sudo yum update -y",
      "sudo yum install python3-pip -y",
      "cd /home/ec2-user",
      "sudo pip3 install flask",
      "sudo python3 app.py &"
    ]
  }
}
