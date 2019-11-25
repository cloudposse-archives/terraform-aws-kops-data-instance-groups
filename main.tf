locals {
  cluster_tag = "kubernetes.io/cluster/${var.cluster_name}"
}

data "aws_autoscaling_groups" "nodes" {
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
  filter {
    name   = "key"
    values = ["k8s.io/role/bastion"]
  }

  filter {
    name   = "value"
    values = [1]
  }
}

data "aws_autoscaling_group" "nodes" {
  count = length(data.aws_autoscaling_groups.nodes.names)
  name  = element(data.aws_autoscaling_groups.nodes.names, count.index)
}

data "aws_autoscaling_group" "masters" {
  count = length(data.aws_autoscaling_groups.masters.names)
  name  = element(data.aws_autoscaling_groups.masters.names, count.index)
}

data "aws_autoscaling_group" "bastions" {
  count = length(data.aws_autoscaling_groups.masters.names)
  name  = element(data.aws_autoscaling_groups.masters.names, count.index)
}

data "aws_launch_configuration" "nodes" {
  for_each = toset(data.aws_autoscaling_group.nodes.*.launch_configuration)
  name     = each.key
}

data "aws_launch_configuration" "masters" {
  for_each = toset(data.aws_autoscaling_group.masters.*.launch_configuration)
  name     = each.key
}

data "aws_launch_configuration" "bastions" {
  for_each = toset(data.aws_autoscaling_group.bastions.*.launch_configuration)
  name     = each.key
}

locals {
  nodes = { for autoscale_group in data.aws_autoscaling_group.nodes :
    // autoscale_group.name => merge(autoscale_group, { launch_configuration = data.aws_launch_configuration.nodes[autoscale_group.launch_configuration] })
    autoscale_group.name => autoscale_group
  }

  masters = { for autoscale_group in data.aws_autoscaling_group.masters :
    autoscale_group.name => merge(autoscale_group, { launch_configuration = data.aws_launch_configuration.masters[autoscale_group.launch_configuration] })
  }

  bastions = { for autoscale_group in data.aws_autoscaling_group.bastions :
    autoscale_group.name => merge(autoscale_group, { launch_configuration = data.aws_launch_configuration.bastions[autoscale_group.launch_configuration] })
  }
}