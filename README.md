# AWS Global

This repository/workspace manages any common resources that are not region-specific.

## DNS

Manages authoritative zones with custom name servers.

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authoritative\_zones | List of DNS zones to create/manage | `list(string)` | n/a | yes |
| delegation\_set\_id | Identifier for pre-existing delegation set | `string` | n/a | yes |
| hostmaster | Email address of hostmaster | `string` | n/a | yes |
| tags | Common tags for created resources | `map(any)` | `{}` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-restore -->