# Infrastructure as Code with Terraform and Kubernetes

This repository contains Terraform configurations for setting up a production-grade infrastructure on AWS, including EKS cluster, networking, monitoring, and CI/CD components.

## Architecture Overview

The infrastructure consists of:
- VPC with public and private subnets across multiple availability zones
- EKS cluster for Kubernetes workloads
- Application Load Balancer (ALB) for ingress traffic
- Monitoring stack with Prometheus and Grafana
- ArgoCD for GitOps deployments
- Auto-scaling configuration for optimal resource utilization

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- kubectl installed and configured
- Helm 3.x

## Project Structure

```
.
├── backend/                 # Terraform backend configuration
├── terraform/              # Main Terraform configurations
│   ├── modules/           # Reusable Terraform modules
│   │   ├── alb/          # Load Balancer configuration
│   │   ├── eks/          # EKS cluster configuration
│   │   ├── network/      # VPC and networking
│   │   └── monitoring/   # Monitoring stack
│   ├── main.tf           # Main Terraform configuration
│   ├── variables.tf      # Variable definitions
│   └── terraform.tfvars  # Variable values
```

## Getting Started

1. Initialize the backend:
   ```bash
   cd backend
   terraform init
   terraform apply
   ```

2. Initialize and apply the main infrastructure:
   ```bash
   cd ../terraform
   terraform init
   terraform plan
   terraform apply
   ```

3. Configure kubectl for EKS:
   ```bash
   aws eks update-kubeconfig --name <cluster-name> --region <region>
   ```

## Module Documentation

### Network Module
Creates a VPC with public and private subnets, NAT gateways, and necessary routing.

### EKS Module
Provisions an EKS cluster with managed node groups and necessary IAM roles.

### ALB Module
Sets up Application Load Balancer and required IAM roles for the AWS Load Balancer Controller.

### Monitoring Module
Deploys Prometheus and Grafana for infrastructure and application monitoring.

## Security Considerations

- All S3 buckets have public access blocked
- EKS cluster endpoint is private
- Secrets are managed through AWS Secrets Manager
- Network security follows AWS best practices

## Maintenance

### State Management
- Terraform state is stored in S3 with versioning enabled
- State locking is implemented using DynamoDB
- Old state versions are automatically cleaned up after 90 days

### Backup and Recovery
- EKS cluster state is backed up regularly
- Critical configurations are version controlled
- Disaster recovery procedures are documented

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

