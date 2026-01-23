provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "hanu-aws-project-zero-to-hero"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cluster_name                = var.cluster_name
  vpc_cidr                    = var.vpc_cidr
  instance_tenancy            = var.instance_tenancy
  public_subnet_count         = var.public_subnet_count
  private_subnet_count        = var.private_subnet_count
  public_subnet_cidr_offset   = var.public_subnet_cidr_offset
  private_subnet_cidr_offset  = var.private_subnet_cidr_offset
  map_public_ip_on_launch     = var.map_public_ip_on_launch
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  node_subnet_ids  = module.vpc.private_subnet_ids

  node_group_name = var.node_group_name
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  instance_types  = var.instance_types
  disk_size       = var.disk_size

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )

  depends_on = [module.vpc]
}