resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}


# Public subnets

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_cidr_1
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = var.availability_zones[0]

  tags = {
    Name : "${var.env_prefix}-public-subnet-1"
  }
}


resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_cidr_2
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = var.availability_zones[1]

  tags = {
    Name : "${var.env_prefix}-public-subnet-2"
  }
}

# Private subnets

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_cidr_1
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = var.availability_zones[0]

  tags = {
    Name : "${var.env_prefix}-private-subnet-1"
  }
}


resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_cidr_2
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = var.availability_zones[1]

  tags = {
    Name : "${var.env_prefix}-private-subnet-2"
  }
}

# IGW

resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name : "${var.env_prefix}-igw"
  }
}


# Elastic IP

resource "aws_eip" "eip-for-nat-gw" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.production-igw]

  tags = {
    Name : "${var.env_prefix}-eip"
  }
}


# NAT Gateway

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_eip.eip-for-nat-gw]

  tags = {
    Name : "${var.env_prefix}-nat-gw"
  }
}

# Route tables

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production-igw.id
  }

  tags = {
    Name : "${var.env_prefix}-public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name : "${var.env_prefix}-private-route-table"
  }
}

# Route table associations

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}
