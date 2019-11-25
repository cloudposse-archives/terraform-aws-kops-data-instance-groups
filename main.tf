locals {
  vpc_id      = var.vpc_id == "" && var.enabled ? concat(data.aws_vpc.kops.*.id, [""])[0] : var.vpc_id
  cluster_tag = "kubernetes.io/cluster/${var.cluster_name}"
}

data "aws_autoscaling_groups" "nodes" {
  filter {
    name   = "KubernetesCluster"
    values = [var.cluster_name]
  }

  filter {
    name   = "k8s.io/role/node"
    values = [1]
  }
}

data "aws_autoscaling_groups" "masters" {
  filter {
    name   = "KubernetesCluster"
    values = [var.cluster_name]
  }

  filter {
    name   = "k8s.io/role/master"
    values = [1]
  }
}

data "aws_autoscaling_groups" "bastions" {
  filter {
    name   = "KubernetesCluster"
    values = [var.cluster_name]
  }

  filter {
    name   = "k8s.io/role/bastion"
    values = [1]
  }
}

data "aws_autoscaling_group" "nodes" {
  for_each = toset(data.aws_autoscaling_groups.nodes.names)
  name     = each.key
}

data "aws_autoscaling_group" "masters" {
  for_each = toset(data.aws_autoscaling_groups.masters.names)
  name     = each.key
}

data "aws_autoscaling_group" "bastions" {
  for_each = toset(data.aws_autoscaling_groups.bastions.names)
  name     = each.key
}

data "aws_launch_configuration" "nodes" {
  for_each = toset(data.aws_autoscaling_group.nodes.launch_configuration)
  name     = each.key
}

data "aws_launch_configuration" "masters" {
  for_each = toset(data.aws_autoscaling_group.masters.launch_configuration)
  name     = each.key
}

data "aws_launch_configuration" "bastions" {
  for_each = toset(data.aws_autoscaling_group.bastions.launch_configuration)
  name     = each.key
}

locals {
  nodes = { for autoscale_group_name, autoscale_group in data.aws_autoscaling_group.nodes :
    autoscale_group_name => merge(autoscale_group, {launch_configuration = data.aws_launch_configuration.nodes[autoscale_group["launch_configuration"]]})
  }

  masters = { for autoscale_group_name, autoscale_group in data.aws_autoscaling_group.masters :
    autoscale_group_name => merge(autoscale_group, {launch_configuration = data.aws_launch_configuration.masters[autoscale_group["launch_configuration"]]})
  }

  bastions = { for autoscale_group_name, autoscale_group in data.aws_autoscaling_group.bastions :
    autoscale_group_name => merge(autoscale_group, {launch_configuration = data.aws_launch_configuration.bastions[autoscale_group["launch_configuration"]]})
  }
}