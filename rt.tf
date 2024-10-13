resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_with_public_subnets.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  route {
    cidr_block = aws_vpc.vpc_with_public_subnets.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "public-rt"
    App = "rsschl"
  }
}

resource "aws_route_table_association" "a_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}