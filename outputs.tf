output "dns_delegations" {
  description = "Delegation and glue records for each authoritative zone."
  value = [for zone in var.authoritative_zones :
    {
      zone         = zone
      name_servers = module.dns[zone].name_servers
    }
  ]
}
