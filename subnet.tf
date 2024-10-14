resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_with_public_subnets.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
    App  = "rsschl"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc_with_public_subnets.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
    App  = "rsschl"
  }
}