#main.tf

#CREDENTIALS
provider "aws" {
  region = "us-east-1"
}

#VPC FOR NETWORK
resource "aws_vpc" "jvnVPC" {
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  cidr_block           = "10.3.0.0/16"
  tags = {
    Name = "jvnVPC"
  }
}

#SUBNET PUBLIC 
resource "aws_subnet" "jvnsn-public" {
  vpc_id            = aws_vpc.jvnVPC.id
  cidr_block        = "10.3.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "jvnsn-public"
  }
}

#SUBNET PRIVATE
resource "aws_subnet" "jvnsn-private" {
  vpc_id            = aws_vpc.jvnVPC.id
  cidr_block        = "10.3.100.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "jvnsn-private"
  }
}

#ROUTE TABLE FOR PUBLIC SUBNET
resource "aws_route_table" "jvn-public-rt" {
  vpc_id = aws_vpc.jvnVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terragatwey.id
  }
  tags = {
    Name = "jvn-public-rt"
  }
}

#ROUTE TABLE FOR PRIVATE SUBNET
resource "aws_route_table" "jvn-private-rt" {
  vpc_id = aws_vpc.jvnVPC.id
  tags = {
    Name = "jvn-private-rt"
  }
}

#ROUTE TABLE ASSOCIATION FOR PUBLIC SUBNET
resource "aws_route_table_association" "jvnr-public-rta" {
  subnet_id      = aws_subnet.jvnsn-public.id
  route_table_id = aws_route_table.jvn-public-rt.id
}

#ROUTE TABLE ASSOCIATION FOR PRIVATE SUBNET
resource "aws_route_table_association" "jvnr-private-rta" {
  subnet_id      = aws_subnet.jvnsn-private.id
  route_table_id = aws_route_table.jvn-private-rt.id
}

#NAT GATEWAY FOR CONNECT SUBNET PRIVATE WITH INTERNET
resource "aws_nat_gateway" "jvnGW-nat" {
  allocation_id = aws_eip.jvn-nat-eip.id
  subnet_id     = aws_subnet.jvnsn-public.id
  depends_on    = [aws_internet_gateway.terragatwey]
}

#ASSIGN EIP FOR NAT GATEWAY
resource "aws_eip" "jvn-nat-eip" {
  vpc        = "true"
  depends_on = [aws_internet_gateway.terragatwey]
}

#GATEWAY
resource "aws_internet_gateway" "terragatwey" {
  vpc_id = aws_vpc.jvnVPC.id
  tags = {
    Name = "terragatwey"
  }
}

#SECURITY GROUP CONTROLS THE TRAFFIC
resource "aws_security_group" "jvnSG" {
  name   = "jvnSG"
  vpc_id = aws_vpc.jvnVPC.id

  # INBOUND
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #OUTBOUND
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jvnSG"
  }
}

#INSTANCE TESTE A
resource "aws_instance" "Desafio_globo" {
  ami                         = "ami-0747bdcabd34c712a"
  instance_type               = "t2.micro"
  disable_api_termination     = "false"
  key_name                    = "acesso_miami"
  user_data                   = file("user-data.sh")
  vpc_security_group_ids      = [aws_security_group.jvnSG.id]
  subnet_id                   = aws_subnet.jvnsn-public.id
  associate_public_ip_address = "true"
  tags = {
    Name = "DesafioGB"
  }
}