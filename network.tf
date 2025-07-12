resource "aws_vpc" "this" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = local.availability_zones

  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.1.${each.value.public_octet}.0/24"
  availability_zone = each.value.az_name

  tags = {
    Name = "${local.name_prefix}-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = local.availability_zones

  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.1.${each.value.private_octet}.0/24"
  availability_zone = each.value.az_name

  tags = {
    Name = "${local.name_prefix}-private-subnet-${each.key}"
  }
}

resource "aws_eip" "nat" {
  for_each = local.availability_zones
  domain   = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = local.availability_zones

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${local.name_prefix}-nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "alb" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.name_prefix}-alb-route-table"
  }
}

resource "aws_route_table_association" "alb" {
  for_each = local.availability_zones

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.alb.id
}

resource "aws_route_table" "backend" {
  for_each = local.availability_zones
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${local.name_prefix}-backend-route-table-${each.key}"
  }
}

resource "aws_route_table_association" "backend" {
  for_each = local.availability_zones

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.backend[each.key].id
}


