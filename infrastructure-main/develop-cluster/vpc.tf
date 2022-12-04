resource "aws_vpc" "vpc_develop_cluster" {
  cidr_block           = var.cidr_dev_vpc
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-develop-cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_vpc_dhcp_options_association" "assoc_dhcp_dev_stockperks_internal" {
  vpc_id          = aws_vpc.vpc_develop_cluster.id
  dhcp_options_id = var.dhcp_options_id_dev_vpc

  lifecycle {
    prevent_destroy = true
  }
}

#private_subnet_us-east-1a
resource "aws_subnet" "private_subnet_us-east-1a" {
  vpc_id            = aws_vpc.vpc_develop_cluster.id
  cidr_block        = var.cidr_dev_private_subnet_us-east-1a
  availability_zone = "us-east-1a"


  tags = {
    Name = "private-subnet-1-develop-cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route_table_association" "assoc_rtb_private_subnet_us-east-1a" {
  subnet_id      = aws_subnet.private_subnet_us-east-1a.id
  route_table_id = var.route_table_id_dev_private_subnet_us-east-1a
  lifecycle {
    prevent_destroy = true
  }
}
#private_subnet_us-east-1b
resource "aws_subnet" "private_subnet_us-east-1b" {
  vpc_id            = aws_vpc.vpc_develop_cluster.id
  cidr_block        = var.cidr_dev_private_subnet_us-east-1b
  availability_zone = "us-east-1b"


  tags = {
    Name = "private-subnet-2-develop-cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_route_table_association" "assoc_rtb_private_subnet_us-east-1b" {
  subnet_id      = aws_subnet.private_subnet_us-east-1b.id
  route_table_id = var.route_table_id_dev_private_subnet_us-east-1b
  lifecycle {
    prevent_destroy = true
  }
}

#public_subnet_us-east-1a
resource "aws_subnet" "public_subnet_us-east-1a" {
  vpc_id                  = aws_vpc.vpc_develop_cluster.id
  cidr_block              = var.cidr_dev_public_subnet_us-east-1a
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1-develop-cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_route_table_association" "assoc_rtb_public_subnet_us-east-1a" {
  subnet_id      = aws_subnet.public_subnet_us-east-1a.id
  route_table_id = var.route_table_id_dev_public_subnets
  lifecycle {
    prevent_destroy = true
  }
}


#public_subnet_us-east-1b
resource "aws_subnet" "public_subnet_us-east-1b" {
  vpc_id                  = aws_vpc.vpc_develop_cluster.id
  cidr_block              = var.cidr_dev_public_subnet_us-east-1b
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2-develop-cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_route_table_association" "assoc_rtb_public_subnet_us-east-1b" {
  subnet_id      = aws_subnet.public_subnet_us-east-1b.id
  route_table_id = var.route_table_id_dev_public_subnets
  lifecycle {
    prevent_destroy = true
  }
}
