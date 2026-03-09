bucket         = "terraform-state-tommy-infra-v1"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform_state_locking"
encrypt        = true 
 