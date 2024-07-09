resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "main-nat-gateway"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"  # Specify the AZ

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"  # Specify the AZ

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_3_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-2c"  # Specify the AZ

  tags = {
    Name = "public-subnet-3"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_1_cidr

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_2_cidr

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_3_cidr

  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table" "vpn" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_vpn_gateway.main.id
  }

  tags = {
    Name = "vpn-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_vpn_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "private_vpn_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_route_table_association" "private_vpn_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.vpn.id
}

resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-vpn-gateway"
  }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main.id
  type = "ipsec.1"

  tags = {
    Name = "main-vpn-connection"
  }
}

resource "aws_customer_gateway" "main" {
  bgp_asn = 65000
  ip_address = "203.0.113.12"  # Replace with your on-premises IP address
  type = "ipsec.1"

  tags = {
    Name = "main-customer-gateway"
  }
}

resource "aws_route53_zone" "main" {
  name = "mydomain.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"
  ttl     = "300"
  records = [aws_lb.app_lb.dns_name]
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web_server.public_ip]
}
