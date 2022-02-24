resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.storage
  engine                 = var.db_engine
  engine_version         = var.engine_version
  storage_type           = var.storage_type
  instance_class         = var.instance_type
  name                   = var.name
  username               = var.username
  password               = var.password
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = var.rds_subnet_group
  vpc_security_group_ids = [var.vpc_security_group_ids]
}
