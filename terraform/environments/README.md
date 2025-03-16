# Environment Management

This directory contains environment-specific configurations for the infrastructure. Each environment has its own state file and variables, ensuring complete isolation between environments.

## Structure

```
environments/
├── dev/
│   ├── backend.hcl        # Dev state backend configuration
│   └── terraform.tfvars   # Dev-specific variables
├── prod/
│   ├── backend.hcl        # Prod state backend configuration
│   └── terraform.tfvars   # Prod-specific variables
└── README.md             # This file
```

## State Management

Each environment's state is stored in a dedicated path in the S3 bucket:
- Dev: `s3://terraform-state-tommy/dev/terraform.tfstate`
- Prod: `s3://terraform-state-tommy/prod/terraform.tfstate`

This separation ensures that:
- State files are isolated between environments
- No risk of dev changes affecting prod
- Clear audit trail per environment
- Easy to add new environments

## Usage

1. Switch to an environment:
```bash
./switch-env.sh dev    # or prod
```

2. Plan changes:
```bash
terraform plan -var-file=environments/dev/terraform.tfvars
```

3. Apply changes:
```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

## Environment-Specific Variables

Each environment can customize:
- VPC and subnet CIDR ranges
- Availability zones
- Resource sizing and scaling
- Feature flags and toggles

### Dev Environment
- VPC CIDR: 10.0.0.0/16
- Subnets: Smaller ranges for cost optimization
- Minimal resource requests/limits

### Prod Environment
- VPC CIDR: 10.1.0.0/16
- Subnets: Larger ranges for growth
- Production-grade resource configurations

## Adding a New Environment

1. Create a new directory:
```bash
mkdir environments/staging
```

2. Copy and modify configuration files:
```bash
cp environments/dev/backend.hcl environments/staging/
cp environments/dev/terraform.tfvars environments/staging/
```

3. Update the backend.hcl:
```hcl
bucket         = "terraform-state-tommy"
key            = "staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform_state_locking"
encrypt        = true
```

4. Customize terraform.tfvars for the new environment

## Best Practices

1. Always use the switch-env.sh script to change environments
2. Review plans carefully before applying
3. Use meaningful commit messages for environment changes
4. Document environment-specific configurations
5. Keep production configurations in version control
6. Use separate AWS credentials per environment 