resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.prefix}-vpc"
  }
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "${var.prefix}-private-sub-${var.availability_zone[count.index]}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.subnet_cidr_public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_public[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    "Name" = "${var.prefix}-public-sub-${var.availability_zone[count.index]}",
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_default_route_table" "vpc_rt_default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id


  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.subnet_cidr_public)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_default_route_table.vpc_rt_default.id
}

resource "aws_eip" "nat_gateway_eip_1" {
  domain = "vpc"
}


resource "aws_eip" "nat_gateway_eip_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_eip_1.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.prefix}-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_eip_2.id
  subnet_id     = aws_subnet.public_subnet[1].id

  tags = {
    Name = "${var.prefix}-nat-gw-2"
  }
}

resource "aws_route_table" "nat_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  # }

  tags = {
    Name = "${var.prefix}-route-table-private"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.subnet_cidr_private)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat_rt.id
}