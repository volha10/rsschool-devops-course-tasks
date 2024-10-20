resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet-gateway"
    App  = "rsschl"
  }
}