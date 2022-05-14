provider "aws" {
  region = "us-west-2"
}
#Pamata VPC
resource "aws_vpc" "pamata" {
  cidr_block = "10.0.0.0/18"
  tags = {
    Name = "3_grupa_Edijs_Grube_Pamata_VPC"
  }
}

#Publisks_1
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.pamata.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "3_grupa_Edijs_Grube_Public_subnet_1"
  }
}

#Publisks_2
resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.pamata.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "3_grupa_Edijs_Grube_Public_subnet_2"
  }
}

#Privatais_1
resource "aws_subnet" "private1" {
  vpc_id = aws_vpc.pamata.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "3_grupa_Edijs_Grube_Private_subnet_1"
  }
}
#Privatais_2
resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.pamata.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "3_grupa_Edijs_Grube_Private_subnet_2"
  }
}

#Internet GTW
resource "aws_internet_gateway" "internet_gtw" {
  vpc_id = aws_vpc.pamata.id
  tags = {
    Name = "3_grupa_Edijs_Grube_Internet_gtw"
  }
}

#Elastic IP for NAT GW
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.internet_gtw]
  tags = {
    Name = "3_grupa_Edijs_Grube_NAT_GW_IP"
  }
}

