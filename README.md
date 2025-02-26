# Infrastructure as Code with Terraform and Kubernetes

This repository contains Terraform configurations for setting up a cost-effective, production-grade infrastructure on AWS, including EKS cluster, networking, monitoring, and CI/CD components.

## Features

- VPC with public/private subnets across availability zones
- EKS cluster with optimized node configuration
- Application Load Balancer with AWS Load Balancer Controller
- Monitoring stack (Prometheus & Grafana)
- ArgoCD for GitOps deployments
- Cluster & Pod Autoscaling with metrics server
- Multi-environment support with isolated state files
- Enhanced security features for state management

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- kubectl
- Helm 3.x

## Project Structure

```
.
├── bootstrap/              # State management infrastructure setup
├── terraform/
│   ├── environments/      # Environment-specific configurations
│   │   ├── dev/          # Development environment configs
│   │   │   ├── backend.hcl
│   │   │   └── terraform.tfvars
│   │   ├── prod/         # Production environment configs
│   │   │   ├── backend.hcl
│   │   │   └── terraform.tfvars
│   │   └── README.md     # Environment management documentation
│   ├── modules/           
│   │   ├── network/      # VPC, subnets, NAT Gateway
│   │   ├── eks/         # EKS cluster configuration
│   │   ├── alb/         # Application Load Balancer
│   │   ├── alb-controller/# AWS Load Balancer Controller
│   │   ├── monitoring/  # Prometheus & Grafana stack
│   │   ├── autoscaling/ # Cluster & Pod autoscaling
│   │   └── argocd/      # Basic ArgoCD setup
│   ├── main.tf          # Main infrastructure
│   ├── variables.tf     # Variable definitions
│   └── providers.tf     # Provider configurations
```

## Getting Started

1. Initialize the state management infrastructure:
   ```bash
   cd bootstrap
   terraform init
   terraform apply
   ```

2. Deploy to an environment (dev/prod):
   ```bash
   cd ../terraform
   # For development
   terraform init -backend-config=environments/dev/backend.hcl
   terraform plan -var-file=environments/dev/terraform.tfvars
   terraform apply -var-file=environments/dev/terraform.tfvars

   # For production
   terraform init -backend-config=environments/prod/backend.hcl
   terraform plan -var-file=environments/prod/terraform.tfvars
   terraform apply -var-file=environments/prod/terraform.tfvars
   ```

3. Configure kubectl:
   ```bash
   aws eks update-kubeconfig --name eks-cluster --region <region>
   ```

## Environment Management

Each environment (dev/prod) has:
- Isolated state files in S3
- Environment-specific variables
- Separate backend configurations
- Independent resource naming

The environments are completely isolated from each other, ensuring:
- No accidental cross-environment changes
- Clear separation of configurations
- Independent state management
- Environment-specific customization

## State Management Security

The state management infrastructure includes:
- Encrypted S3 bucket with versioning
- MFA delete protection
- Access logging enabled
- SSL-only access enforcement
- DynamoDB table encryption
- CloudWatch monitoring
- IAM access policies
- Public access blocking

## Cost Optimization

- Single NAT Gateway instead of one per AZ
- Efficient instance type selection (t3.medium)
- Conservative autoscaling settings (2-4 nodes)
- Minimal resource requests/limits
- 7-day monitoring data retention
- Disabled optional features

## Security Features

- Private EKS endpoint with public access enabled
- Security groups for all components
- IAM roles with least privilege
- OIDC integration for service accounts
- Encrypted S3 state bucket with MFA delete
- DynamoDB state locking with encryption
- SSL enforcement for state access
- Access logging and monitoring

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Create a Pull Request

## License

MIT License

For detailed documentation of each module, please refer to the README files in their respective directories.

## Architecture Diagram

![alt text](https://github.com/tommyzab/iac-tf-k8s-infrastructure/blob/main/EKS-TF.png)
