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
