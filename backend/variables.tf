variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
  validation {
    condition     = length(var.bucket_name) >= 3
    error_message = "Bucket name must be at least 3 characters long."
  }
}

variable "region" {
  description = "AWS region where the backend resources will be created"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm for S3 bucket (AES256 or aws:kms)"
  type        = string
  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "SSE algorithm must be either AES256 or aws:kms."
  }
}

variable "billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "Billing mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}
