locals {
  common_tags = {
    Environment = var.environment
    Application = var.application
    ManagedBy   = "terraform"
  }
}

