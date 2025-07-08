terraform {
  backend "s3" {
    bucket         = "state-S3-bucket"
    key            = "eks/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
