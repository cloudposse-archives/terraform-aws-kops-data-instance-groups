## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | The Kubernetes cluster name | string | - | yes |
| enabled | Set to false to prevent the module from creating or accessing any resources | string | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastions | Autoscale groups created for bastions instance groups |
| bastions_tags | Tags of bastions instance groups |
| common_tags | Common tags for all instance groups |
| masters | Autoscale groups created for masters instance groups |
| masters_tags | Tags of masters instance groups |
| nodes | Autoscale groups created for node instance groups |
| nodes_tags | Tags of nodes instance groups |

