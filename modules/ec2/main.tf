resource "aws_key_pair" "ullas_key" {
  key_name   = "ssh_key"
  public_key = file("/home/ullas/.ssh/id_rsa.pub")
}

data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  count                       = length(var.public_subnets)
  ami                         = data.aws_ami.amazon.id
  instance_type               = "t2.micro"
  subnet_id                   = element(var.public_subnets, count.index)
  vpc_security_group_ids      = [var.vpc_security_group_ids]
  associate_public_ip_address = true
  key_name                    = "ssh_key"

  tags = {
    Name = "web_instance-${count.index}"
  }
}