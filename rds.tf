resource "aws_db_subnet_group" "subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  tags = {
    Name = "Customer subnet group only for private subnets"
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage          = var.rds_db_storage
  identifier                 = var.db_name
  db_name                    = var.db_name
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  username                   = var.username
  password                   = var.password
  db_subnet_group_name       = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  parameter_group_name       = "default.mysql8.0"
  skip_final_snapshot        = true
  auto_minor_version_upgrade = false
}