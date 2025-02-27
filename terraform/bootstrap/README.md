# Terraform State Bootstrap

This module creates the necessary resources for managing Terraform state across multiple environments.

## Resources Created

1. S3 bucket for state storage
   - Versioning enabled
   - Server-side encryption
   - Public access blocked
   - Environment folders pre-created

2. DynamoDB table for state locking
   - PAY_PER_REQUEST billing mode
   - Point-in-time recovery enabled

## Usage

```bash
cd bootstrap
terraform init
terraform apply
```

This only needs to be run once before setting up any environments.

## Important Notes

1. The S3 bucket has `prevent_destroy = true` to protect against accidental deletion
2. Each environment gets its own folder in the S3 bucket
3. The state for this bootstrap configuration itself is stored locally
4. Make sure to note the bucket and DynamoDB table names for use in environment configurations

## After Bootstrap

Once these resources are created, you can:
1. Delete the old backend folder (it's no longer needed)
2. Use the environment-specific backend configurations
3. Start creating resources in each environment 