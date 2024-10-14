resource "aws_instance" "public_server_1" {
  ami             = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "public_server_1"
    App  = "rsschl"
  }
}

resource "aws_instance" "public_server_2" {
  ami             = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_2.id
  security_groups_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "public_server_2"
    App  = "rsschl"
  }
}