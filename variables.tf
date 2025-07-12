variable "domain_name" {
  description = "Domain name for SSL certificate"
  type        = string
  default     = "example.com"

}

variable "zone_name" {
  description = "Cloudflare zone name"
  type        = string
  default     = "example.com"

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.zone_name))
    error_message = "The zone_name must be a valid domain name format (e.g., example.com)."
  }
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.cloudflare_api_token) >= 40
    error_message = "The cloudflare_api_token must be at least 40 characters long."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["production", "staging", "development", "dev", "prod", "stage"], var.environment)
    error_message = "The environment must be one of: production, staging, development, dev, prod, stage."
  }
}

variable "google_client_id" {
  description = "Google OAuth App Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth App Client Secret"
  type        = string
  sensitive   = true
}