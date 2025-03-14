# Network Module

Creates VPC infrastructure with public and private subnets.

## Features
- VPC with DNS support
- Public and private subnets across AZs
- Single NAT Gateway for cost optimization
- Internet Gateway for public access

## Usage

```hcl
module "network" {
  source = "./modules/network"

  prefix              = "myapp"
  vpc_cidr           = "10.0.0.0/16"
  availability_zone  = ["us-east-1a", "us-east-1b"]
  subnet_cidr_private = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_cidr_public  = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

## Requirements
- AWS provider
- Subnets must be within VPC CIDR range
- Minimum of 2 availability zones recommended

## Cost Considerations

- Uses a single NAT Gateway instead of one per AZ to reduce costs
- Minimal but effective subnet structure
- No VPC Flow Logs to avoid additional logging costs

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_cidr | CIDR block for VPC | string | yes |
| region | AWS Region | string | yes |
| prefix | Resource name prefix | string | yes |
| availability_zone | List of AZs | list(string) | yes |
| subnet_cidr_private | Private subnet CIDR blocks | list(string) | yes |
| subnet_cidr_public | Public subnet CIDR blocks | list(string) | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| private_subnet_ids | List of private subnet IDs |
| public_subnet_ids | List of public subnet IDs | 