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

#NAT GW 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id 
  subnet_id = aws_subnet.public1.id
  tags = { 
    Name = "3_grupa_Edijs_Grube_NAT_GW"
  }
}
#Public route table
resource "aws_route_table" "public1" {
   vpc_id = aws_vpc.pamata.id 
   route { 
     cidr_block ="0.0.0.0/0"
     gateway_id = aws_internet_gateway.internet_gtw.id
   }
   tags = {
     Name = "3_grupa_Edijs_Grube_Public1_routing_table"
   }
}

#Route associate public1
resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}

#Private1 route table
resource "aws_route_table" "private1" {
   vpc_id = aws_vpc.pamata.id
   route {
     cidr_block ="0.0.0.0/0"
     gateway_id = aws_nat_gateway.nat.id
   }
   tags = {
     Name = "3_grupa_Edijs_Grube_Private1_routing_table"
   }
}

#Route associate Private1
resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}


#Firewall 443
resource "aws_security_group" "allow_443" {
  name        = "allow_443"
  description = "Allow 443 inbound traffic"
  vpc_id      = aws_vpc.pamata.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_tls"
  }
}
#Firewall 80
resource "aws_security_group" "allow_80" {
  name        = "allow_80"
  description = "Allow 80 inbound traffic"
  vpc_id      = aws_vpc.pamata.id

  ingress {
    description      = "Http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_http"
  }
}

#Firewall SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_SSH"
  description = "Allow 22 inbound traffic"
  vpc_id      = aws_vpc.pamata.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["81.198.46.221/32"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

