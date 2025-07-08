#  AWS EKS Infrastructure with Terraform

This project provisions a secure, scalable, and production-ready **EKS Cluster on AWS** using **Terraform modules**. It supports **staging** and **production** environments using separate configs and shared modules.

---

##  Features

-  Modular Terraform architecture
-  Custom VPC with public subnets
-  EKS Cluster with 3 worker nodes
-  Cluster Autoscaler
-  IAM roles for deployment and worker nodes
-  Remote state stored in S3 with state locking using DynamoDB
-  Environment-based setup: **staging** and **production**

---

##  Directory Structure

```

terraform/
├── backend.tf                  # Shared backend configuration
├── main.tf                     # Root entry (not used directly)
├── variables.tf                # Common variables
├── environments/
│   ├── staging/
│   │   ├── main.tf
│   │   └── backend.tf
│   └── production/
│       ├── main.tf
│       └── backend.tf
├── modules/
│   ├── vpc/                    # Custom VPC and subnets
│   ├── eks/                    # EKS cluster and node groups
│   ├── iam/                    # IAM roles and policies         
└── README.md                   # This file

````

---

##  Prerequisites

- AWS CLI and credentials configured (`~/.aws/credentials`)
- Terraform 1.3+
- A pre-created S3 bucket and DynamoDB table for state backend


---

##  Module Overview

###  VPC
Creates:
- 1 VPC
- 2 public subnets
- Internet Gateway
- Route Tables

###  IAM
Creates:
- IAM role for deploy user

###  EKS
Creates:
- EKS control plane
- 3-node managed node group
- Helm-based autoscaler can be optionally added


---

##  Backend Configuration

Each environment uses its own backend config.

### Example: `environments/staging/backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "eks/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
````

> Replace `"staging"` with `"production"` for the prod environment.

---

##  How to Deploy

### 1. Initialize Terraform

```bash
cd terraform/environments/staging
terraform init
```

### 2. Preview the Changes

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

Repeat for production:

```bash
cd terraform/environments/production
terraform init
terraform apply
```

---

## Autoscaler (Optional Helm Setup)

After cluster is provisioned, install Cluster Autoscaler using Helm:

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler \
  --namespace kube-system \
  --set awsRegion=us-east-1 \
  --set autoDiscovery.clusterName=staging-cluster \
  --set rbac.create=true
```


##  Managing Environments

Each environment lives in its own folder:

* `environments/staging`
* `environments/production`

Both reuse shared modules under `modules/`.

---