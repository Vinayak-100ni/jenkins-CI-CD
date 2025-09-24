terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "allow_connection" {
  name        = "allow TLS"
  vpc_id      = aws_default_vpc.default.id
  
  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "stockhol-key"
  security_groups = [aws_security_group.allow_connection.name]

  tags = {
    Name = "create infra for cicd"
  }
  root_block_device {
    volume_size = 10 
    volume_type = "gp3"
  }
}
