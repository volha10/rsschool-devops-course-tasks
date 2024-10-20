resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_with_public_subnets.id

  tags = {
    Name = "internet-gateway"
    App  = "rsschl"
  }
}