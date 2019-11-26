## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | The Kubernetes cluster name | string | - | yes |
| enabled | Set to false to prevent the module from creating or accessing any resources | string | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastions | Bastions autoscale groups + launch configurations |
| masters | Masters autoscale groups + launch configurations |
| nodes | Nodes autoscale groups + launch configurations |

