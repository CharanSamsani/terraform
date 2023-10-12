output "ec2_name" {
  description = "Instance name"
  value = aws_instance.charan.tags.Name
}

output "public_ip_addr" {
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
