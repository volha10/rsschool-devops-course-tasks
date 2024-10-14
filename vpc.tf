resource "aws_vpc" "vpc_with_public_subnets" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-with-public-subnets"
    App  = "rsschl"
  }
}