resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + var.public_subnet_cidr_offset}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                     = "1"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = var.availability_zone_state
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + var.private_subnet_cidr_offset}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
  depends_on = [aws_vpc.main]
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.cluster_name}-nat"
  }
  depends_on = [aws_internet_gateway.main]
}

# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-private-rt"
  }
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
