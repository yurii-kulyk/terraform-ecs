provider "aws" {
  region  = var.region
  profile = var.profile
}

module "production-network" {
  source                = "./modules/network"
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zones    = var.availability_zones
  env_prefix            = var.env_prefix
}
