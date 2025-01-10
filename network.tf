resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "TechSavvyVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = var.public_subnet_name[count.index]
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name    = var.private_subnet_name[count.index]
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_route_table" "route_table" {
  count  = length(var.route_table)
  vpc_id = aws_vpc.vpc.id
  dynamic "route" {
    for_each = var.route_table[count.index] == "Public_RT" ? [1] : []
    content {
      cidr_block = var.cidr_all
      gateway_id = aws_internet_gateway.igw.id
    }
  }
  tags = {
    Name    = element(var.route_table, count.index)
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.route_table[0].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.route_table[1].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = var.igw_name
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg
  description = "SG for RDS instance inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = var.rds_sg
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress" {
  security_group_id = aws_security_group.rds_sg.id
  description       = "RDS access allowed only from VPC"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = var.db_port
  ip_protocol       = var.ip_protocol
  to_port           = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "rds_sg_egress" {
  security_group_id = aws_security_group.rds_sg.id
  description       = "Outbound traffic"
  cidr_ipv4         = var.cidr_all
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "vm_sg" {
  name        = var.vm_sg
  description = "SG for VM instance inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = var.vm_sg
    VPCName = "${aws_vpc.vpc.tags.Name}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_sg_ingress" {
  security_group_id = aws_security_group.vm_sg.id
  description       = "SSH access allowed to VM"
  cidr_ipv4         = var.cidr_all # you can keep this ip to own ip for demo i am keeping open for all
  from_port         = var.ssh_port
  ip_protocol       = var.ip_protocol
  to_port           = var.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "http_sg_ingress" {
  security_group_id = aws_security_group.vm_sg.id
  description       = "http access allowed to VM"
  cidr_ipv4         = var.cidr_all
  from_port         = var.http_port
  ip_protocol       = var.ip_protocol
  to_port           = var.http_port
}

resource "aws_vpc_security_group_egress_rule" "vm_sg_egress" {
  security_group_id = aws_security_group.vm_sg.id
  description       = "Outbound traffic"
  cidr_ipv4         = var.cidr_all
  ip_protocol       = "-1" # semantically equivalent to all ports
}
