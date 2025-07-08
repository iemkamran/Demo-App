module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id
  enable_irsa     = true

  node_groups = {
    default = {
      desired_capacity = 3
      max_capacity     = 4
      min_capacity     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  manage_aws_auth_configmap = true
  create_eks = true
}
