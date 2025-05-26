resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, {
    Name = "${var.env}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.env}-igw"
  })
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]
  tags = merge(var.tags, {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  })
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.tags, {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  })
}

resource "aws_route_table" "public_rt" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.env}-public-rt-${count.index}"
  })
}

resource "aws_route" "internet_access" {
  count = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_rta" {
  count = length(aws_subnet.public_subnet)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

resource "aws_eip" "this" {
  tags = merge(var.tags, {
    Name = "${var.env}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id = aws_subnet.public_subnet[0].id
  tags = merge(var.tags, {
    Name = "${var.env}-nat-gateway"
  })
}

resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.env}-private-rt-${count.index}"
  })
}

resource "aws_route" "private_nat" {
  count = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_rta" {
  count = length(aws_subnet.private_subnet)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}