module "acm_certificate" {
  source  = "flaconi/acm-cloudflare/aws"
  version = "~> 1.5.0"

  domain_name          = var.domain_name
  zone_name            = var.zone_name
  cloudflare_api_token = var.cloudflare_api_token

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  tags = {
    Name        = "${local.name_prefix}-certificate"
    Environment = var.environment
    Project     = local.name_prefix
  }
}