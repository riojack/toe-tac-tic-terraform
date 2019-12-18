provider "aws" {
  profile = "default"
  region  = "us-east-1"
  version = "~> 2.42"
}

terraform {
  backend "s3" {
    bucket = "f3a5c1584c71-tf-remote-state"
    key    = "tac-tic-toe/tf-state"
    region = "us-east-1"
  }
}

resource "aws_vpc" "toe_tac_tic_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name   = "TTT VPC"
    Source = "Terraform"
  }
}

resource "aws_subnet" "toe_tac_tic_subnet" {
  vpc_id            = aws_vpc.toe_tac_tic_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name   = "TTT Subnet"
    Source = "Terraform"
  }
}

resource "aws_network_interface" "toe_tac_tic_nic" {
  subnet_id   = aws_subnet.toe_tac_tic_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name   = "TTT NIC"
    Source = "Terraform"
  }
}

resource "aws_spot_instance_request" "toe_tac_tic_instance" {
  ami                    = "ami-009d6802948d06e52"
  instance_type          = "t2.small"
  spot_type              = "one-time"
  spot_price             = "0.018"
  block_duration_minutes = 60
  network_interface {
    network_interface_id = aws_network_interface.toe_tac_tic_nic.id
    device_index         = 0
  }

  tags = {
    Name   = "El Cheapo Tiny"
    Source = "Terraform"
  }
}
