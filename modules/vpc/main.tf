#Create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr
  tags = {
    Name = var.name
  }
}

#Create Subnets - Private and Public
resource "aws_subnet" "private" {
  count      = length(var.priv_cidr)
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = element(var.priv_cidr, count.index)

  tags = {
    Name = "priv_sub_${count.index}"
  }
}

resource "aws_subnet" "public" {
  count      = length(var.pub_cidr)
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = element(var.pub_cidr, count.index)

  tags = {
    Name = "pub_sub_${count.index}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc-igw"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "gw_NAT"
  }
  depends_on = [aws_internet_gateway.igw]
}

#Assign EIP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT_eip"
  }
}

#Create Route Table and its associations
resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub_route"
  }
}

resource "aws_route_table_association" "pub_route_associate" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table" "priv_route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "priv_route"
  }
}

resource "aws_route_table_association" "priv_route_associate" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.priv_route.id
}

#Create Security Groups for EC2 and RDS instances
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "SSH Connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_connection]
  }

  ingress {
    description = "5432 Connection"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

#Create DB Subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "rds_subnet_group"
  }
}