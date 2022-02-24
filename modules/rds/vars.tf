variable "storage" {
  default = 10
}

variable "db_engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "13.1"
}

variable "storage_type" {
  default = "gp2"
}

variable "instance_type" {
  default = "db.t3.micro"
}

variable "name" {
  default = "postgre_database"
}

variable "username" {
  default = "foo"
}

variable "password" {
  default = "foobar1234"
}

variable "skip_final_snapshot" {
  default = true
}

variable "rds_subnet_group" {
  description = "Subnet group for rds"
}

variable "vpc_security_group_ids" {
  description = "security group of EC2"
}