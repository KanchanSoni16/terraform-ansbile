output "VM_Public_IP" {
  value = aws_instance.virtual_machine.public_ip
}

output "RDS_Instance_Endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

