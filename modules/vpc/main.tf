resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true

    assign_generated_ipv6_cidr_block = tru
    tags = {
        Name = "${var.project}-${var.environment}-vpc"
    }
}

data "aws_availability_zones" "available_zones" {}


resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet
    map_public_ip_on_launch = true
    availability_zone       = data.aws_availability_zones.available_zones.names[0]  


    ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 1)}"
    assign_ipv6_address_on_creation = true

    tags = {
        Name = "${var.project}-${var.environment}-dual-stack"
    }
}

resource "aws_subnet" "public_subnet_az1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.public_subnet_2
    availability_zone       = data.aws_availability_zones.available_zones.names[1]  

 
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project}-${var.environment}-public-az1"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "${var.project}-${var.environment}-public-rt"
    }
}


resource "aws_route_table_association" "public_subnet_az1_rt_association" {
    subnet_id      = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "public_subnet_2_rt_association" {
    subnet_id      = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.public_route_table.id
}