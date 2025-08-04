module "eks" {
    
    # import the module template
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.31"

    # cluster information (control plane)
    cluster_name    = local.name
    cluster_version = "1.31"
    cluster_endpoint_public_access = true

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    cluster_addons = {
            vpc-cni = {
                most-recent = true
            }
            kube-proxy = {
                most-recent = true
            }
            coredns = {
                most-recent = true
            }
        }

    # control plane network
    control_plane_subnet_ids = module.vpc.intra_subnets

    # managing nodes in the cluster
    eks_managed_node_group_defaults = {

        instance_types = ["t2.medium"]
        attach_cluster_primary_security_group = true
    }

    eks_managed_node_groups = {
        arh-cluster-ng = {
            instance_types = ["t2.medium"]

            min_size = 1
            max_size = 3
            desired_size = 2

            capacity_type = "SPOT"
        }
    }


    tags = {
        Environment = local.env
        Terraform = "true"
    }
}