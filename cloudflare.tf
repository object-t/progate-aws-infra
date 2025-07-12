data "cloudflare_zone" "domain" {
  name = var.zone_name
}

resource "cloudflare_record" "api_gateway" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "naoapi"
  content = aws_api_gateway_domain_name.domain.regional_domain_name
  type    = "CNAME"
  proxied = false
}

