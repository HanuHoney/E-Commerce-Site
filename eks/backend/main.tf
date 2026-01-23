provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "example" {
  bucket = "hanu-aws-project-zero-to-hero"
  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_dynamodb_table" "terraform_eks_state_locks" {
  name         = "terraform_eks_state_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}