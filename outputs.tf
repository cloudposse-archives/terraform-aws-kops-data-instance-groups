output "nodes" {
  value       = flatten(data.aws_autoscaling_groups.nodes.*.names)
  description = "Nodes autoscale groups + launch configurations"
}

output "masters" {
  value       = flatten(data.aws_autoscaling_groups.masters.*.names)
  description = "Masters autoscale groups + launch configurations"
}

output "bastions" {
  value       = flatten(data.aws_autoscaling_groups.bastions.*.names)
  description = "Bastions autoscale groups + launch configurations"
}

output "nodes_tags" {
  value       = local.node_tags
  description = "Nodes autoscale groups + launch configurations"
}

output "masters_tags" {
  value       = local.master_tags
  description = "Masters autoscale groups + launch configurations"
}

output "bastions_tags" {
  value       = local.bastion_tags
  description = "Bastions autoscale groups + launch configurations"
}

output "common_tags" {
  value       = local.common_tags
  description = "Nodes autoscale groups + launch configurations"
}
