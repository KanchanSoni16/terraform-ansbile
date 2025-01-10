resource "aws_instance" "virtual_machine" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  iam_instance_profile   = aws_iam_role.ec2_s3.id
  key_name               = "NVKey"
  tags = {
    Name = "TechSavvyVM"
  }
}