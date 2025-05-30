

resource "cloudflare_dns_record" "this" {
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_sub_domain_name
  content = var.cloudflare_record_content
  ttl     = 3600
  type    = "CNAME"
  proxied = false
}
