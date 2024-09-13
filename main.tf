
provider "aws" {
  region = var.region
}

module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "ec2_autoscaling" {
  source           = "./modules/ec2_autoscaling"
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  user_data        = file("user_data.sh") // Include a user_data script to install PHP
}

output "ec2_public_ip" {
  value = module.ec2_autoscaling.public_ip
}
