resource "aws_eks_cluster" "jar" {
  name     = "jar"
#   role_arn = aws_iam_role.example.arn
    role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = [var.subnet_id, var.subnet_id2]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role.eks-iam-role
    # aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role" "eks-iam-role" {
 name = "cil-academy-eks-cluster-role"

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

resource "aws_eks_node_group" "jar" {
  cluster_name    = aws_eks_cluster.jar.name
  node_group_name = "jar-group"
  node_role_arn   = aws_iam_role.eks-iam-role.arn
  subnet_ids      = [var.subnet_id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
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