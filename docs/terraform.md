## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The Kubernetes cluster name | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating or accessing any resources | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastions | Autoscale groups created for bastions instance groups |
| bastions\_tags | Tags of bastions instance groups |
| common\_tags | Common tags for all instance groups |
| masters | Autoscale groups created for masters instance groups |
| masters\_tags | Tags of masters instance groups |
| nodes | Autoscale groups created for node instance groups |
| nodes\_tags | Tags of nodes instance groups |

