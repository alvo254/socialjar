resource "aws_eks_cluster" "jar" {
  name     = "jar"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    # vpc_id = var.vpc
    subnet_ids = [var.subnet_id, var.subnet_id2]
  }
  # enabled_cluster_log_types = [
  #   "api",
  #   "audit",
  #   "authenticator",
  #   "controllerManager",
  #   "scheduler"
  # ]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role.eks-iam-role
    # aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role" "eks-iam-role" {
 name = "jar-eks-cluster-role"

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": ["eks.amazonaws.com", "ec2.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

data "template_file" "user_data" {
  template = file("${path.module}/worker-node-policy.json")
}

data "template_file" "cni" {
  template = file("${path.module}/eks-cni-policy.json")
}


# Define the IAM policy for AmazonEKS_CNI_Policy
resource "aws_iam_policy" "cni_policy" {
  name        = "AmazonEKS_cni_node_Policy"
  description = "cni policy"
  policy = data.template_file.cni.rendered
}


# Define the IAM policy for AmazonEKS_worker_node_Policy
resource "aws_iam_policy" "worker_node_policy" {
  name        = "AmazonEKS_worker_node_Policy"
  description = "IAM policy for Amazon nodes"
  policy = data.template_file.user_data.rendered
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attachment" {
  policy_arn = aws_iam_policy.worker_node_policy.arn
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_attachment" {
  policy_arn = aws_iam_policy.cni_policy.arn
  role       = aws_iam_role.eks-iam-role.name
}


resource "aws_key_pair" "jar" {
  key_name = "jar-key"
  //storing ssh key on the server
  public_key = tls_private_key.RSA.public_key_openssh
}

resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "alvo-ssh-keys" {
	# content = tls_private_key.RSA.private_key_pem
	content = tls_private_key.RSA.private_key_pem
	filename = "alvo-ssh-keys.pem"
}

resource "aws_eks_node_group" "jar" {
  cluster_name    = aws_eks_cluster.jar.name
  node_group_name = "jar-group"
  node_role_arn   = aws_iam_role.eks-iam-role.arn
  subnet_ids      = [var.subnet_id, var.subnet_id2]
  # capacity_type = "On-demand"

  remote_access {
    ec2_ssh_key = aws_key_pair.jar.key_name
    source_security_group_ids = [var.security_group]
  }


  scaling_config {
    desired_size = 2 //Number of nodes needed at creation
    max_size     = 2 //Max number of nodes that we can scale up to
    min_size     = 1 //Min number of nodes the group can scale down to
  }

  update_config {
    max_unavailable = 1
  }


  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role.eks-iam-role
    # aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    # aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    # aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "kubernetes_node_taint" "jar" {
  
  metadata {
    name = aws_eks_node_group.jar.node_group_name

  }
  taint {
    key    = "node.cilium.io/agent-not-ready"
    value  = "true"
    effect = "NoExecute"
  }
}


//To test
# resource "null_resource" "delete_aws_cni" {
#   provisioner "local-exec" {
#     command = "curl -s -k -XDELETE -H 'Authorization: Bearer ${data.aws_eks_cluster_auth.eks_vpc_us_east_1.token}' -H 'Accept: application/json' -H 'Content-Type: application/json' '${data.aws_eks_cluster.eks_vpc_us_east_1.endpoint}/apis/apps/v1/namespaces/kube-system/daemonsets/aws-node'"
#   }
# }

# resource "null_resource" "delete_kube_proxy" {
#   provisioner "local-exec" {
#     command = "curl -s -k -XDELETE -H 'Authorization: Bearer ${data.aws_eks_cluster_auth.eks_vpc_us_east_1.token}' -H 'Accept: application/json' -H 'Content-Type: application/json' '${data.aws_eks_cluster.eks_vpc_us_east_1.endpoint}/apis/apps/v1/namespaces/kube-system/daemonsets/kube-proxy'"
#   }
# }

# resource "kubernetes_config_map" "cni_config" {
#   metadata {
#     name      = "cni-configuration"
#     namespace = "kube-system"
#   }
#   data = {
#     "cni-config" = <<EOF
# {
#   "cniVersion":"0.3.1",
#   "name":"cilium",
#   "plugins": [
#     {
#       "cniVersion":"0.3.1",
#       "type":"cilium-cni",
#       "eni": {
#         "first-interface-index": 1,
#         "subnet-tags":{
#           "Usage":"pods"
#         }        
#       }
#     }
#   ]
# }
# EOF
#   }
# }

# resource "kubernetes_pod_disruption_budget_v1" "jar" {
#   metadata {
#     name = "jar"
#   }
#   spec {
#     max_unavailable = "20%"
#     selector {
#       match_labels = {
#         test = "myapp"
#       }
#     }
#   }
# }