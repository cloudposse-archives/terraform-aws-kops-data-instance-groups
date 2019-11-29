data "aws_autoscaling_groups" "nodes" {
  count = var.enabled ? 1 : 0
  filter {
    name   = "key"
    values = ["k8s.io/role/node"]
  }

  filter {
    name   = "value"
    values = [1]
  }
}

data "aws_autoscaling_groups" "masters" {
  count = var.enabled ? 1 : 0
  filter {
    name   = "key"
    values = ["k8s.io/role/master"]
  }

  filter {
    name   = "value"
    values = [1]
  }
}

data "aws_autoscaling_groups" "bastions" {
  count = var.enabled ? 1 : 0
  filter {
    name   = "key"
    values = ["k8s.io/role/bastion"]
  }

  filter {
    name   = "value"
    values = [1]
  }
}

locals {
  nodes    = flatten(data.aws_autoscaling_groups.nodes.*.names)
  masters  = flatten(data.aws_autoscaling_groups.masters.*.names)
  bastions = flatten(data.aws_autoscaling_groups.bastions.*.names)

  common_tags = [
    {
      key   = "Cluster"
      value = var.cluster_name
    },
    {
      key   = "KubernetesCluster"
      value = var.cluster_name
    }
  ]

  node_tags = [
    {
      key   = "k8s.io/role/node"
      value = 1
    }
  ]

  master_tags = [
    {
      key   = "k8s.io/role/master"
      value = 1
    }
  ]

  bastion_tags = [
    {
      key   = "k8s.io/role/bastion"
      value = 1
    }
  ]
}