bucket         = "terraform-state-tommy"
key            = "prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform_state_locking"
encrypt        = true 