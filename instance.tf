# Bastion Host in Public Subnet 1
resource "aws_instance" "public_server_1" {
  ami                    = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = "Ec2AccessForRsSchool"

  lifecycle {
    replace_triggered_by = [aws_security_group.bastion_sg]
  }

  tags = {
    Name = "public-server-1"
    App  = "rsschl"
  }
}

# accessible only via Bastion
resource "aws_instance" "private_server_1" {
  ami                    = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.allow_internal_inbound_outbound_traffic.id]
  key_name               = "Ec2AccessForRsSchool"

  lifecycle {
    replace_triggered_by = [aws_security_group.allow_internal_inbound_outbound_traffic]
  }

  tags = {
    Name = "private-server-1"
    App  = "rsschl"
  }
}


resource "aws_instance" "private_server_2" {
  ami                    = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.allow_internal_inbound_outbound_traffic.id]
  key_name               = "Ec2AccessForRsSchool"

  tags = {
    Name = "private-server-2"
    App  = "rsschl"
  }
}

