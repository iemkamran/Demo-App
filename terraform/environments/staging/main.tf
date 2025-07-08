provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  env    = "staging"
}

module "iam" {
  source = "../../modules/iam"
  env    = "staging"
}

module "eks" {
  source       = "../../modules/eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
  cluster_name = "staging-cluster"
}

module "vault" {
  source = "../../modules/vault"
}
