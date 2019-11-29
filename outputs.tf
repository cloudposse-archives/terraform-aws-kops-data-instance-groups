output "nodes" {
  value       = flatten(data.aws_autoscaling_groups.nodes.*.names)
  description = "Autoscale groups created for node instance groups"
}

output "masters" {
  value       = flatten(data.aws_autoscaling_groups.masters.*.names)
  description = "Autoscale groups created for masters instance groups"
}

output "bastions" {
  value       = flatten(data.aws_autoscaling_groups.bastions.*.names)
  description = "Autoscale groups created for bastions instance groups"
}

output "nodes_tags" {
  value       = local.node_tags
  description = "Tags of nodes instance groups"
}

output "masters_tags" {
  value       = local.master_tags
  description = "Tags of masters instance groups"
}

output "bastions_tags" {
  value       = local.bastion_tags
  description = "Tags of bastions instance groups"
}

output "common_tags" {
  value       = local.common_tags
  description = "Common tags for all instance groups"
}
