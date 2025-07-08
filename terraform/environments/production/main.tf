provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  env    = "production"
}

module "iam" {
  source = "../../modules/iam"
  env    = "production"
}

module "eks" {
  source       = "../../modules/eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  cluster_name = "production-cluster"
}

module "vault" {
  source = "../../modules/vault"
}
