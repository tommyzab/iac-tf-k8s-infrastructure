terraform {
  backend "s3" {
    bucket = "terraform-state-tommy"
    key = "global/s3/terraform.tfstate"
    region = var.region
    dynamodb_table = "terraform_state_locking"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}