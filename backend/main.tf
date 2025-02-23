provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
  
}

resource "aws_s3_bucket_versioning" "versioning_tf_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse_tf_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = var.dynamodb_table_name
  billing_mode = var.billing_mode
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

