resource "aws_vpc" "vpc_a" {
  cidr_block = var.cidr_vpc_a

  tags = {
    Name = "VPC-A"
  }
}

resource "aws_vpc" "vpc_b" {
  cidr_block = var.cidr_vpc_b

  tags = {
    Name = "VPC-B"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = var.cidr_subnet_a
  availability_zone = "${local.region}c"

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = var.cidr_subnet_b
  availability_zone = "${local.region}a"

  tags = {
    Name = "subnet-b"
  }
}

resource "aws_route_table_association" "rta_a" {
  route_table_id = aws_vpc.vpc_a.main_route_table_id
  subnet_id      = aws_subnet.subnet_a.id
}

resource "aws_route_table_association" "rta_b" {
  route_table_id = aws_vpc.vpc_b.main_route_table_id
  subnet_id      = aws_subnet.subnet_b.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "vpc_a2b" {
  route_table_id            = aws_vpc.vpc_a.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "vpc_b2a" {
  route_table_id            = aws_vpc.vpc_b.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_network_interface" "eni_a" {
  subnet_id   = aws_subnet.subnet_a.id
  private_ips = [var.private_ip_a]

  tags = {
    Name = "eni-a"
  }
}

resource "aws_network_interface" "eni_b" {
  subnet_id   = aws_subnet.subnet_b.id
  private_ips = [var.private_ip_b]

  tags = {
    Name = "eni-b"
  }
}

resource "aws_vpc_peering_connection" "main" {
  vpc_id      = aws_vpc.vpc_a.id
  peer_vpc_id = aws_vpc.vpc_b.id
  auto_accept = true

  # disable: <ip_address>.me-central-1.compute.internal
  requester {
    allow_remote_vpc_dns_resolution = false
  }

  # disable: <ip_address>.me-central-1.compute.internal
  accepter {
    allow_remote_vpc_dns_resolution = false
  }

  tags = {
    Name = "my-vpc-peering-01"
  }
}
