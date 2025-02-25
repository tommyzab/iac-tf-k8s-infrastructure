# Infrastructure as Code with Terraform and Kubernetes

This repository contains Terraform configurations for setting up a cost-effective, production-grade infrastructure on AWS, including EKS cluster, networking, monitoring, and CI/CD components.

## Architecture Diagram

![EKS Architecture](eks-tf.png)

The diagram above illustrates the high-level architecture of our infrastructure. Note that while the diagram shows NAT gateways in both availability zones, our implementation uses a single NAT gateway for cost optimization.

## Architecture Overview

The infrastructure consists of:
- VPC with public and private subnets across multiple availability zones
- Single NAT Gateway (cost-optimized)
- EKS cluster with SPOT instances
- Application Load Balancer (ALB) with AWS Load Balancer Controller
- Monitoring stack with Prometheus and Grafana (optimized configuration)
- ArgoCD for basic GitOps deployments
- Cluster Autoscaling with metrics server

## Cost Optimization Features
- Single NAT Gateway instead of one per AZ
- SPOT instances for EKS nodes
- Conservative autoscaling settings
- Minimal but sufficient resource requests/limits
- Disabled unnecessary features (AlertManager, Dex)
- 7-day retention for monitoring data

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- kubectl installed and configured
- Helm 3.x

## Project Structure

```
.
├── backend/                 # Terraform state management configuration
│   ├── main.tf             # S3 bucket and DynamoDB table configuration
│   ├── variables.tf        # Backend variables
│   ├── outputs.tf          # Backend outputs
│   └── terraform.tfvars    # Backend variable values
├── terraform/              # Main infrastructure configuration
│   ├── modules/           
│   │   ├── network/       # VPC, subnets, NAT Gateway
│   │   ├── eks/          # EKS cluster with SPOT instances
│   │   ├── alb/          # Application Load Balancer
│   │   ├── alb-controller/# AWS Load Balancer Controller
│   │   ├── monitoring/   # Prometheus & Grafana stack
│   │   ├── autoscaling/  # Cluster & Pod autoscaling
│   │   └── argocd/       # Basic ArgoCD setup
│   ├── main.tf           # Main infrastructure
│   ├── variables.tf      # Variable definitions
│   └── terraform.tfvars  # Variable values
```

## Module Details

### Network Module
- VPC with public and private subnets
- Single NAT Gateway for cost optimization
- Basic routing tables and internet gateway

### EKS Module
- Managed Kubernetes cluster (v1.27)
- SPOT instances for cost efficiency (t3.medium)
- Basic node group configuration (2-4 nodes)
- OIDC provider configuration

### ALB Module
- Application Load Balancer in public subnets
- Basic HTTP listener configuration
- Security group with HTTP/HTTPS access

### ALB Controller Module
- AWS Load Balancer Controller (v1.4.4)
- IAM roles and policies for ALB management
- Helm-based deployment

### Monitoring Module
- Prometheus with 7-day retention
- Grafana with persistent storage (1Gi)
- LoadBalancer service type for access
- Disabled AlertManager for resource efficiency
- Basic resource limits and requests

### Autoscaling Module
- Cluster Autoscaler
- Metrics Server (v3.12.0)
- Conservative scaling policies
- Basic HPA configuration
- Resource-based scaling (CPU/Memory)

### ArgoCD Module
- Basic ArgoCD installation (v3.35.4)
- Minimal resource configuration
- LoadBalancer service type
- Disabled optional features (Dex, notifications)

## Getting Started

1. Set up the backend infrastructure:
   ```bash
   cd backend
   terraform init
   terraform plan
   terraform apply
   ```

2. Deploy the main infrastructure:
   ```bash
   cd ../terraform
   terraform init
   terraform plan
   terraform apply
   ```

3. Configure kubectl:
   ```bash
   aws eks update-kubeconfig --name <cluster-name> --region <region>
   ```

## Security Features

- Private EKS endpoint with public access
- Security groups for all components
- IAM roles with least privilege
- OIDC integration for service accounts
- No public S3 access

## Maintenance

### State Management
- S3-based state storage with versioning
- DynamoDB state locking
- 90-day state version expiration
- STANDARD_IA transition after 30 days

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Create a Pull Request

## License

This project is licensed under the MIT License.

