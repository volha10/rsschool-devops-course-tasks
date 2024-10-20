# Public rt
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_with_public_subnets.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-rt"
    App  = "rsschl"
  }
}

resource "aws_route_table_association" "public_route_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_route_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private rt
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_with_public_subnets.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id

  }

  tags = {
    Name = "private-rt"
    App  = "rsschl"
  }
}


resource "aws_route_table_association" "private_route_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_route_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id

}