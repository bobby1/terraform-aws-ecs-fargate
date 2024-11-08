# Declare the availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}

### Create the VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name             = "${var.business_division}-${var.environment}-main_vpc"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
### Create the public subnet - 2 
resource "aws_subnet" "public" {
  count                   = var.subnet_count[var.environment]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name             = "${var.business_division}-${var.environment}-public_subnet-${count.index}"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
### Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name             = "${var.business_division}-${var.environment}-main_igw"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
### Public route table
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name             = "${var.business_division}-${var.environment}-Public-RT"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
# We use the count meta argument to dynamically retrieve the id’s of our public subnet that were dynamically generated.
resource "aws_route" "rtb-public-route" {
  route_table_id         = aws_route_table.rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "pub-rtb-asoc" {
  count          = var.subnet_count[var.environment]
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rtb-public.id
}
### Create the private subnet
resource "aws_subnet" "private" {
  count      = var.subnet_count[var.environment]
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  tags = {
    Name             = "${var.business_division}-${var.environment}-private_subnet-${count.index}"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
resource "aws_eip" "eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id
  # NAT gateway is created in the public subnet but used by the private subnet
  tags = {
    Name             = "${var.business_division}-${var.environment}-gw NAT"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
# To ensure proper ordering, it is recommended to add an explicit dependency
### Private route table
resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name             = "${var.business_division}-${var.environment}-Public-RT"
    business_divsion = var.business_division
    environment      = var.environment
  }
}
resource "aws_route" "rtb-private-route" {
  route_table_id         = aws_route_table.rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}
resource "aws_route_table_association" "priv-rtb-asoc" {
  count          = var.subnet_count[var.environment]
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rtb-private.id
}