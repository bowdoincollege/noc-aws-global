locals {
  tags = merge({
    createdby     = "terraform"
    costcenter    = "240340"
    environment   = "prod"
    documentation = "https://github.com/bowdoincollege/noc-aws-global"
  }, var.tags)
}

module "dns" {
  for_each          = toset(var.authoritative_zones)
  source            = "./dns"
  zone              = each.key
  hostmaster        = var.hostmaster
  delegation_set_id = var.delegation_set_id
  tags              = local.tags
}
