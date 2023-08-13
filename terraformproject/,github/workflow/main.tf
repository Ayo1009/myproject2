# main.tf

# Provider configuration for AWS
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# VPC Configuration
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1a" # Change to your desired AZ
  
  map_public_ip_on_launch = true
  
  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.my_vpc.id
  
  # Allow SSH inbound
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTP inbound
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "InstanceSG"
  }
}

# EC2 Instances
resource "aws_instance" "ec2_instances" {
  count = 2
  ami           = "ami-12345678" # Specify a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet[count.index].id
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "EC2-Instance-${count.index}"
  }
}