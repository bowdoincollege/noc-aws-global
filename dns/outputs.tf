output "name_servers" {
  description = "The nameservers and addresses for the zone."
  value = [for ns in data.aws_route53_delegation_set._.name_servers :
    {
      name      = "ns${index(data.aws_route53_delegation_set._.name_servers, ns) + 1}"
      real_name = ns
      ipv4_addr = element(data.dns_a_record_set._[ns].addrs, 0)
      ipv6_addr = element(data.dns_aaaa_record_set._[ns].addrs, 0)
    }
  ]
}
