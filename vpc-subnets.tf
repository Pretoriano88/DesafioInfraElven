
resource "aws_vpc" "mainvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Define sub-redes públicas em diferentes AZs na região us-east-1
resource "aws_subnet" "subnet-public-1a" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, 1) # 10.0.1.0/24
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = var.public_onlaunch

  tags = {
    Name = "Sub-Public-1a"
  }
}

resource "aws_subnet" "subnet-public-1b" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, 2) # 10.0.2.0/24
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = var.public_onlaunch

  tags = {
    Name = "Sub-Public-1b"
  }
}

# Define sub-redes privadas em diferentes AZs na região us-east-1
resource "aws_subnet" "subnet-private-2a" {
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, 3) # 10.0.3.0/24
  availability_zone = "${var.region}a"

  tags = {
    Name = "Sub-Private-1a"
  }
}

resource "aws_subnet" "subnet-private-2b" {
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, 4) # 10.0.4.0/24
  availability_zone = "${var.region}b"

  tags = {
    Name = "Sub-Private-1b"
  }
}

# Grupo de subnets que o RDS pertencerá 
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "dbsubnet"
  subnet_ids = [aws_subnet.subnet-private-2a.id, aws_subnet.subnet-private-2b.id]

  tags = {
    Name = "Grupo do RDS subnets privadas"
  }
}
