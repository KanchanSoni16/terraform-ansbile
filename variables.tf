variable "region" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {
  type = list(string)
}
variable "private_subnet_cidr" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}
variable "public_subnet_name" {
  type = list(string)
}
variable "private_subnet_name" {
  type = list(string)
}
variable "route_table" {
  type = list(string)
}
variable "cidr_all" {}
variable "igw_name" {}
variable "rds_sg" {}
variable "db_port" {}
variable "ip_protocol" {}
variable "rds_db_storage" {}
variable "db_name" {}
variable "username" {
  sensitive = true
}
variable "password" {
  sensitive = true
}
variable "ami" {}
variable "instance_type" {}
variable "vm_sg" {}
variable "ssh_port" {}
variable "http_port" {}
