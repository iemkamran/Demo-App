resource "aws_iam_role" "deploy" {
  name = "${var.env}-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { AWS = "*" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    env = var.env
  }
}
