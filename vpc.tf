# Resource Block
# Resource-1: Create VPC
resource "aws_vpc" "vpc-v2" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  
  tags = {
    Name = "test vpc"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-v2.id
  cidr_block              = var.public-subnet-1-cidr
  availability_zone       = "eu-west-2a"

  tags      = {
    Name    = "public subnet 1 | web"
  }
}


# Create Public Subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-v2.id
  cidr_block              = var.public-subnet-2-cidr
  availability_zone       = "eu-west-2b"
 
    tags    = {
    Name    = "public subnet 2 | web"
  }
}


# Create Public Subnet 3
resource "aws_subnet" "public-subnet-3" {
  vpc_id                  = aws_vpc.vpc-v2.id
  cidr_block              = var.public-subnet-3-cidr
  availability_zone       = "eu-west-2c"
 
  tags      = {
    Name    = "public subnet 2 | web"
  }
}


# Create Private Subnet 1
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc-v2.id
  cidr_block               = var.private-subnet-1-cidr
  availability_zone        = "eu-west-2a"
 
  tags      = {
    Name    = "private subnet 1 | app"
  }
}


# Create Private Subnet 2
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc-v2.id
  cidr_block               = var.private-subnet-2-cidr
  availability_zone        = "eu-west-2b"

  tags      = {
    Name    = "private subnet 2 | app"
  }
}


# Create Private Subnet 3
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc-v2.id
  cidr_block               = var.private-subnet-3-cidr
  availability_zone        = "eu-west-2c"

  tags      = {
    Name    = "private subnet 3 | app"
  }
}


# Create Internet Gateway and Attach it to VPC
resource "aws_internet_gateway" "my-igw" {
  vpc_id    = aws_vpc.vpc-v2.id

  tags      = {
    Name    = "test igw"
  }
}


# Create Route in Route Table for Internet Access
resource "aws_route" "public-route" {
  route_table_id = aws_route_table.public-route-table.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id 
}


# Create Route Table and Add Public Route
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc-v2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags       = {
    Name     = "public route table"
  }
}


# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}


# Associate Public Subnet 3 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-3-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-3.id
  route_table_id      = aws_route_table.public-route-table.id
}



#Create Security Group
resource "aws_security_group" "my-security-group" {
  name        = "my security group"
  description = "VPC Default Security Group"
  vpc_id      = aws_vpc.vpc-v2.id

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
   egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application load Balancer
resource "aws_lb" "alb-tritek" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-security-group.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id ]


  tags = {
    Environment = "production"
  }
}