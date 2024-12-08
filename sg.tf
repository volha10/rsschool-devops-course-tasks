resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow ssh, ping, k8s traffic from anywhere and all outbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  timeouts {
    delete = "2m"
  }
  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_bastion" {
  description       = "Allow ssh from anywhere to bastion host"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping_to_bastion" {
  description       = "Allow ping from anywhere to bastion host"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"


  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_python_app_traffic" {
  description       = "Allow python app k8s access from anywhere to bastion host"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 30080
  to_port           = 30080
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_prometheus_traffic" {
  description       = "Allow prometheus access from anywhere to prometheus host"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 30090
  to_port           = 30090
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_traffic" {
  description       = "Allow jenkins access from anywhere to jenkins host"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_k8s_traffic" {
  description       = "Allow k8s traffic"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_from_bastion" {
  description       = "Allow all outbound traffic to anywhere, e.g. ping private hosts inside vpc or ping outside vpc"
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    App = "rsschl"
  }
}


resource "aws_security_group" "allow_internal_inbound_and_outbound_traffic" {
  name        = "allow-internal-inbound-and-outbound-traffic"
  description = "Allow ssh, ping inside vpc"
  vpc_id      = aws_vpc.main_vpc.id

  timeouts {
    delete = "2m"
  }

  tags = {
    App = "rsschl"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_inbound_traffic_inside_vpc" {
  description       = "Allow all inbound traffic inside vpc"
  security_group_id = aws_security_group.allow_internal_inbound_and_outbound_traffic.id
  ip_protocol       = "-1"
  cidr_ipv4         = aws_vpc.main_vpc.cidr_block

  tags = {
    App = "rsschl"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic_to_anywhere" {
  description       = "Allow all outbound traffic to anywhere"
  security_group_id = aws_security_group.allow_internal_inbound_and_outbound_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    App = "rsschl"
  }
}
