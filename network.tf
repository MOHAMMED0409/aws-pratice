//VPC
resource "aws_vpc" "react-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "react-vpc"
  }
}

//Subnet
resource "aws_subnet" "react-subnet" {
  vpc_id     = aws_vpc.react-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "react-subnet"
  }
}
resource "aws_subnet" "react-subnet-2" {
  vpc_id     = aws_vpc.react-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "react-subnet-2"
  }
}

//Internet Gateway
resource "aws_internet_gateway" "react-igw" {
  vpc_id = aws_vpc.react-vpc.id
  tags = {
    Name = "react-igw"
  }
}

//Route Table
resource "aws_route_table" "react-route" {
  vpc_id = aws_vpc.react-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react-igw.id
  }

  tags = {
    Name = "react-route-table"
  }
}

resource "aws_route_table_association" "react-ass-route" {
  subnet_id      = aws_subnet.react-subnet.id
  route_table_id = aws_route_table.react-route.id
}

//Security Groups

resource "aws_security_group" "react-sg" {
  vpc_id = aws_vpc.react-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "react-sg"
  }
}
