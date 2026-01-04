# Amazon EKS Cluster with Terraform

## Overview

This project provisions a production-ready Amazon Elastic Kubernetes Service (EKS) cluster using Terraform and the official AWS EKS Terraform module. It creates a complete Kubernetes environment with a managed control plane, worker nodes, networking infrastructure, and essential cluster add-ons.

## Architecture

The infrastructure deploys the following AWS resources:

**Kubernetes Control Plane:**
- Managed EKS cluster (version 1.31)
- Public API endpoint access
- Essential cluster add-ons (VPC CNI, kube-proxy, CoreDNS)

**Networking:**
- Custom VPC with multi-AZ deployment
- Public subnets for external-facing resources
- Private subnets for worker nodes
- Intra subnets for control plane networking
- NAT Gateway for private subnet internet access
- VPN Gateway for secure connectivity

**Worker Nodes:**
- Managed node group with auto-scaling
- SPOT instances for cost optimization
- 1-3 nodes (desired: 2)
- t2.medium instance type

## Features

- Fully managed Kubernetes control plane
- Auto-scaling worker node groups
- Multi-AZ high availability architecture
- SPOT instance pricing for cost savings
- Pre-configured cluster add-ons
- Custom VPC with public and private subnets
- NAT and VPN gateway support
- Cluster security group with primary SG attachment
- Infrastructure as code with Terraform modules

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- kubectl installed for cluster access
- AWS account with EKS, EC2, and VPC permissions
- Basic understanding of Kubernetes concepts

## Project Structure

```
Practice_Project2/
├── eks.tf          # EKS cluster and node group configuration
├── vpc.tf          # VPC module configuration
├── locals.tf       # Local values and configuration
├── providers.tf    # AWS provider configuration
└── terraform.tf    # Terraform version requirements
```

## Cluster Configuration

**EKS Cluster:**
- Name: arh-eks-cluster
- Version: Kubernetes 1.31
- Region: us-east-2
- Availability Zones: us-east-2a, us-east-2b

**Networking:**
- VPC CIDR: 10.0.0.0/16
- Public Subnets: 10.0.101.0/24, 10.0.102.0/24
- Private Subnets: 10.0.1.0/24, 10.0.2.0/24
- Intra Subnets: 10.0.5.0/24, 10.0.6.0/24

**Node Group:**
- Name: arh-cluster-ng
- Instance Type: t2.medium
- Capacity Type: SPOT
- Min Size: 1 node
- Max Size: 3 nodes
- Desired Size: 2 nodes

## Cluster Add-ons

The cluster includes the following essential add-ons:

- **VPC CNI**: Networking plugin for pod networking
- **kube-proxy**: Network proxy for Kubernetes services
- **CoreDNS**: DNS server for service discovery

All add-ons are configured to use the most recent versions.

## Deployment

1. Navigate to the project directory
2. Review and customize values in `locals.tf` if needed
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned infrastructure:
   ```bash
   terraform plan
   ```
5. Deploy the EKS cluster:
   ```bash
   terraform apply
   ```
   Note: This may take 15-20 minutes to complete

## Accessing the Cluster

After deployment, configure kubectl to access your cluster:

```bash
aws eks update-kubeconfig --region us-east-2 --name arh-eks-cluster
```

Verify cluster access:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Working with the Cluster

### Deploy a Sample Application

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get services
```

### Scale Node Group

Modify the node group configuration in `eks.tf`:

```hcl
desired_size = 3
```

Then apply changes:

```bash
terraform apply
```

### View Cluster Information

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl top nodes
```

## SPOT Instance Configuration

The node group uses SPOT instances for cost savings:

- Up to 90% cost reduction compared to On-Demand
- Suitable for fault-tolerant workloads
- AWS may reclaim instances with 2-minute notice
- Best for development and testing environments

For production workloads, consider using On-Demand instances:

```hcl
capacity_type = "ON_DEMAND"
```

## Security Features

- EKS cluster with managed control plane security
- Private subnets for worker nodes
- Cluster primary security group attached
- NAT Gateway for secure outbound internet access
- VPN Gateway for secure site-to-site connectivity
- IAM roles for service accounts (IRSA) support

## Monitoring and Logging

Enable CloudWatch logging:

```bash
aws eks update-cluster-config \
  --name arh-eks-cluster \
  --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
```

View logs in CloudWatch Logs console under `/aws/eks/arh-eks-cluster/cluster`.

## Outputs

After deployment, Terraform provides:

- EKS cluster endpoint
- Cluster security group ID
- Cluster IAM role ARN
- Node group details
- VPC and subnet information

## Cost Optimization

**Current Configuration:**
- SPOT instances: ~$0.0208/hour per t2.medium
- 2 nodes: ~$1.00/day
- EKS control plane: $0.10/hour (~$73/month)
- NAT Gateway: ~$0.045/hour (~$32/month)

**Total estimated cost:** ~$135/month

**Optimization tips:**
- Use SPOT instances for non-production workloads
- Right-size instance types based on workload
- Use cluster autoscaler to scale down during off-hours
- Consider Fargate for serverless pods

## Cleanup

To remove all resources and avoid charges:

```bash
# First, delete any Kubernetes LoadBalancer services
kubectl delete svc --all

# Then destroy Terraform infrastructure
terraform destroy
```

Note: This may take 10-15 minutes. Ensure all LoadBalancers are deleted first to prevent orphaned resources.

## Upgrading Kubernetes Version

To upgrade the cluster version:

1. Update `cluster_version` in `eks.tf`:
   ```hcl
   cluster_version = "1.32"
   ```

2. Apply the change:
   ```bash
   terraform apply
   ```

3. Update node group AMI:
   ```bash
   kubectl get nodes
   ```

EKS will perform a rolling upgrade of the control plane.

## Troubleshooting

**Cluster Not Accessible:**
- Verify kubectl configuration is correct
- Check IAM permissions for EKS access
- Ensure VPC networking is properly configured

**Nodes Not Joining:**
- Check node group security group rules
- Verify IAM role permissions
- Review CloudWatch logs for errors

**Pods Not Scheduling:**
- Check node capacity with `kubectl describe nodes`
- Verify resource requests and limits
- Scale node group if needed

## Use Cases

- Learning Kubernetes and EKS
- Containerized application deployment
- Microservices architecture
- CI/CD pipeline testing
- Development and staging environments
- Portfolio project for cloud engineering roles

## Best Practices Implemented

- Multi-AZ deployment for high availability
- Managed node groups for simplified operations
- Latest Kubernetes version
- Essential cluster add-ons pre-installed
- Infrastructure as code with Terraform
- Modular VPC design
- SPOT instances for cost optimization
- Resource tagging for organization

## Extension Ideas

- Add cluster autoscaler for automatic scaling
- Implement pod auto-scaling with HPA
- Configure ALB Ingress Controller
- Set up monitoring with Prometheus and Grafana
- Implement GitOps with ArgoCD or Flux
- Add AWS Load Balancer Controller
- Configure external DNS
- Implement service mesh (Istio, Linkerd)

## License

This project is provided as-is for educational and professional use.
