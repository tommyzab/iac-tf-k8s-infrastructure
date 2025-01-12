# Terraform AWS EKS Project

This project sets up an AWS EKS cluster with various modules for networking, load balancing, monitoring, and more using Terraform.


![alt text](https://github.com/tommyzab/iac-tf-k8s-infrastructure/blob/main/EKS-TF.png)


## Modules

### Network

The `network` module sets up the VPC, subnets, internet gateway, NAT gateways, and route tables. This ensures that the infrastructure is highly available across two availability zones.

### ALB

The `alb` module sets up the Application Load Balancer and its security group. The ALB is internet-facing and is the only resource accessible from the internet.

### EKS

The `eks` module sets up the EKS cluster, IAM roles, and managed node groups. The EKS cluster is deployed in private subnets for security.

### ALB Controller

The `alb-controller` module sets up the AWS Load Balancer Controller using Helm. This controller manages the ALB resources for Kubernetes services.

### Monitoring

The `monitoring` module sets up Prometheus and Grafana using Helm. An ingress is created to expose Grafana on a dedicated ALB for monitoring and alerting.

### ArgoCD

The `argocd` module sets up ArgoCD using Helm. ArgoCD is used for continuous deployment of applications on the EKS cluster.

### Autoscaling

The `autoscaling` module sets up the Cluster Autoscaler and Metrics Server using Helm. This ensures that the EKS nodes can scale up and down based on the load.

## Usage

1. **Initialize Terraform:**

   ```sh
   terraform init
    ```

2. **Plan the deployment:**
   ```sh
   terraform plan
    ```

3. **Apply the deployment:**
   ```sh
   terraform apply
    ```

## Variables

The project uses several variables defined in `terraform/variables.tf` and `backend/variables.tf`. You can override these variables by creating a `backend/terraform.tfvars` file.

## Backend Configuration

The backend configuration is stored in the `backend` folder. It sets up an S3 bucket and DynamoDB table for storing the Terraform state and locks.

## Providers

The project uses the following providers:

- AWS
- Helm
- Kubernetes
- Random
- TLS

## Deployment Details

1. **VPC and Subnets:**
   - Created a VPC with 2 public and 2 private subnets across 2 availability zones.
   - Configured route tables, internet gateway, and NAT gateways for proper routing.

2. **Security Groups:**
   - Defined security groups for ALB and EKS to control inbound and outbound traffic.

3. **EKS Cluster:**
   - Deployed an EKS cluster in private subnets with managed node groups.
   - Configured IAM roles for the EKS cluster and nodes.

4. **Application Load Balancer:**
   - Set up an internet-facing ALB in public subnets to handle incoming traffic.

5. **Monitoring and Alerting:**
   - Deployed Prometheus and Grafana on the EKS cluster using Helm.
   - Created an ingress to expose Grafana on a dedicated ALB.

6. **Cluster Autoscaler:**
   - Configured Cluster Autoscaler to manage the scaling of EKS nodes based on load.

7. **ArgoCD and Application Deployment:**
   - Deployed ArgoCD for continuous deployment.
   - Deployed a "Hello World" NGINX application using ArgoCD.
   - Configured HPA to scale the application based on CPU usage.
   - Deployed AWS ALB Ingress Controller for the NGINX application.

## License

This project is licensed under the MIT License.

