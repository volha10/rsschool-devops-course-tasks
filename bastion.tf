# Bastion Host in Public Subnet 1
resource "aws_instance" "bastion" {
  ami                    = "ami-0592c673f0b1e7665" # al2023-ami-2023.5.20241001.1-kernel-6.1-x86_64
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = "Ec2AccessForRsSchool"

  user_data = file("install_tools.sh")

  lifecycle {
    replace_triggered_by = [aws_security_group.bastion_sg]
  }

  tags = {
    Name = "bastion"
    App  = "rsschl"
  }
}

resource "aws_eip" "bastion_eip" {
  instance   = aws_instance.bastion.id
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
}