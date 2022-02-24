module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source         = "./modules/ec2"
  public_subnets = module.vpc.public_subnets
  vpc_security_group_ids = module.vpc.security_group_for_ec2
}

module "rds" {
  source = "./modules/rds"
  rds_subnet_group = module.vpc.rds_subnet_group
  vpc_security_group_ids = module.vpc.security_group_for_ec2
}