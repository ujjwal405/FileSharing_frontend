data "cloudflare_zone" "this" {
  name = var.cloudflare_zone_name
}

resource "cloudflare_dns_record" "this" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.cloudflare_sub_domain_name
  content = var.cloudflare_record_content
  type    = "CNAME"
  proxied = false
}
