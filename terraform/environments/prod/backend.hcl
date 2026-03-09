bucket         = "terraform-state-tommy-infra-v1"
key            = "prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locking-v1"
encrypt        = true 

