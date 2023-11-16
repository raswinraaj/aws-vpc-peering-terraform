# Create VPC-A
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-A"
  }
}

# Create public subnet in VPC-A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet - VPC-A"
  }
}

# Create private subnet in VPC-A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a" 

  tags = {
    Name = "Private Subnet - VPC-A"
  }
}

# Create VPC-B
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-B"
  }
}

# Create public subnet in VPC-B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1b" 
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet - VPC-B"
  }
}

# Create private subnet in VPC-B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-east-1b" 

  tags = {
    Name = "Private Subnet - VPC-B"
  }
}

# Create peering connection between VPC-A and VPC-B
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_b.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering Connection"
  }
}

# Configure security groups to allow HTTP/HTTPS traffic
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [aws_subnet.public_subnet_a.cidr_block]
  }
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow HTTPS traffic"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [aws_subnet.public_subnet_a.cidr_block]
  }
}
