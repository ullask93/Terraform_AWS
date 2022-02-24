output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "security_group_for_ec2" {
  value = aws_security_group.allow_ssh.id
}

output "rds_subnet_group" {
  value = aws_db_subnet_group.rds_subnet_group.name
}