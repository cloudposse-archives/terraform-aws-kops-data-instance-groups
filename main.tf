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

data "aws_autoscaling_group" "nodes" {
  count = var.enabled ? length(flatten(data.aws_autoscaling_groups.nodes.*.names)) : 0
  name  = element(flatten(data.aws_autoscaling_groups.nodes.*.names), count.index)
}

data "aws_autoscaling_group" "masters" {
  count = var.enabled ? length(flatten(data.aws_autoscaling_groups.masters.*.names)) : 0
  name  = element(flatten(data.aws_autoscaling_groups.masters.*.names), count.index)
}

data "aws_autoscaling_group" "bastions" {
  count = var.enabled ? length(flatten(data.aws_autoscaling_groups.bastions.*.names)) : 0
  name  = element(flatten(data.aws_autoscaling_groups.bastions.*.names), count.index)
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


  nodes = tomap(
    {
      for autoscale_group in data.aws_autoscaling_group.nodes :
      autoscale_group.name => merge(data.aws_launch_configuration.nodes[autoscale_group.launch_configuration],
        {
          tags = concat([{ key = "Name", value = autoscale_group.name }], local.node_tags, local.common_tags)
        }
      )
    }
  )

  masters = tomap(
    {
      for autoscale_group in data.aws_autoscaling_group.masters :
      autoscale_group.name => merge(data.aws_launch_configuration.masters[autoscale_group.launch_configuration],
        {
          tags = concat([{ key = "Name", value = autoscale_group.name }], local.master_tags, local.common_tags)
        }
      )
    }
  )

  bastions = tomap(
    {
      for autoscale_group in data.aws_autoscaling_group.bastions :
      autoscale_group.name => merge(data.aws_launch_configuration.bastions[autoscale_group.launch_configuration],
        {
          tags = concat([{ key = "Name", value = autoscale_group.name }], local.bastion_tags, local.common_tags)
        }
      )
    }
  )
}