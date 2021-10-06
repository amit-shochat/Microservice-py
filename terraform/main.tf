terraform {
  backend "remote" {
    organization = "example-org-11d9e0"

    workspaces {
      name = "micro-app"
    }
  }
}

# --------------Provider -------------------------------

provider "aws" {
  profile = "default"
  region  = local.aws_region
}

# --------------Local's -------------------------------
locals {
  ami           = "ami-00f8e2c955f7ffa9b"
  aws_region    = "us-east-2"
  instance_type = "t2.micro"
  #ssh_key_name = "klika"

  ###tags_name##
  vpc_name              = "microservice-get-vpc"
  gateway_name          = "microservice-get-gateway"
  internet_access_name  = "microservice-get-internet_access"
  subnet_instances_name = "microservice-get-subnet-instances"
}

# --------------Network's -------------------------------
# Create a VPC to launch our instances into
resource "aws_vpc" "microservice_get" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = local.vpc_name
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "microservice_get" {
  vpc_id = aws_vpc.microservice_get.id
  tags = {
    Name = local.gateway_name
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "microservice_get_internet_access" {
  route_table_id         = aws_vpc.microservice_get.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.microservice_get.id

}

# Create a subnet to launch our instances into
resource "aws_subnet" "microservice_get" {
  vpc_id                  = aws_vpc.microservice_get.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = local.subnet_instances_name
  }
}

# --------------Security group's -------------------------------

# --------------Security group ELB -------------------------------
resource "aws_security_group" "elb_microservice_get" {
  name        = "microservice_get_elb"
  description = "microservice create by terraform"
  vpc_id      = aws_vpc.microservice_get.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------Security group user -------------------------------

# Our default security group to access
resource "aws_security_group" "user_microservice_get" {
  name   = "AWS-ELB-MICROSERVICE-GET-USER"
  vpc_id = aws_vpc.microservice_get.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------ELB --------------------------

resource "aws_elb" "elb_microservice_get" {
  name = "AWS-ELB-MICROSERVICE-GET"

  subnets         = [aws_subnet.microservice_get.id]
  security_groups = [aws_security_group.elb_microservice_get.id]
  instances       = aws_instance.microservice_get.*.id


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }
  depends_on = [aws_instance.microservice_get]

}

# --------------- Instance Configuration ---------------

resource "aws_instance" "microservice_get" {
  count                  = var.instance_count
  instance_type          = local.instance_type
  ami                    = local.ami
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.user_microservice_get.id]
  subnet_id              = aws_subnet.microservice_get.id
  user_data              = file("pull_run-microservice.sh")
  tags = {
    Name = "microservice_get-${count.index + 1}"
  }
}
