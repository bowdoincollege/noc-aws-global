# Provision a route53 zone using custom nameserver addresses from a pre-existing
# reusable delegation set.
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/white-label-name-servers.html

data "aws_route53_delegation_set" "_" {
  id = var.delegation_set_id
}

resource "aws_route53_zone" "_" {
  name              = var.zone
  delegation_set_id = data.aws_route53_delegation_set._.id
  tags              = var.tags
}

# look up addresses for each delegation
data "dns_a_record_set" "_" {
  for_each = toset(data.aws_route53_delegation_set._.name_servers)
  host     = each.key
}
data "dns_aaaa_record_set" "_" {
  for_each = toset(data.aws_route53_delegation_set._.name_servers)
  host     = each.key
}

resource "aws_route53_record" "ns-a" {
  for_each = toset(data.aws_route53_delegation_set._.name_servers)
  zone_id  = aws_route53_zone._.id
  name     = "ns${index(data.aws_route53_delegation_set._.name_servers, each.key) + 1}"
  type     = "A"
  ttl      = 172800
  records  = data.dns_a_record_set._[each.key].addrs
}

resource "aws_route53_record" "ns-aaaa" {
  for_each = toset(data.aws_route53_delegation_set._.name_servers)
  zone_id  = aws_route53_zone._.id
  name     = "ns${index(data.aws_route53_delegation_set._.name_servers, each.key) + 1}"
  type     = "AAAA"
  ttl      = 172800
  records  = data.dns_aaaa_record_set._[each.key].addrs
}

# AWS pre-provisions the NS and SOA records to the zone, so terraform
# cannot manage these (without importing them).  Since this is a
# one-off, just use local awscli to modify the existing records.

locals {
  hostmaster = "${replace(var.hostmaster, "@", ".")}."
  update_ns_soa = {
    Changes = [
      {
        Action = "UPSERT"
        ResourceRecordSet = {
          Name = var.zone
          Type = "NS"
          TTL  = 172800
          ResourceRecords = [
            for n in range(1, 5) : { Value = "ns${n}.${var.zone}" }
          ]
        }
      },
      {
        Action = "UPSERT"
        ResourceRecordSet = {
          Name = var.zone
          Type = "SOA"
          TTL  = 172800
          ResourceRecords = [{
            Value = "ns1.${var.zone}. ${local.hostmaster} 1 7200 900 1209600 86400"
          }]
        }
      }
    ]
  }
}

resource "null_resource" "update_ns_soa" {
  depends_on = [
    aws_route53_record.ns-a,
    aws_route53_record.ns-aaaa,
  ]
  triggers = {
    zone_id = aws_route53_zone._.id
  }
  provisioner "local-exec" {
    command = "aws route53 change-resource-record-sets --hosted-zone-id ${aws_route53_zone._.id} --change-batch '${jsonencode(local.update_ns_soa)}'"
  }
}
