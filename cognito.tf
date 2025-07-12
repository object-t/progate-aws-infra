resource "aws_cognito_user_pool" "this" {
  name = "${local.name_prefix}-user-pool"

  deletion_protection = "ACTIVE"

  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }

  auto_verified_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "preferred_username"
    required            = false
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  tags = {
    Name = "${local.name_prefix}-user-pool"
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "${local.name_prefix}-auth-${random_string.domain_suffix.result}"
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "random_string" "domain_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
    authorize_scopes = "email profile openid"
  }

  attribute_mapping = {
    email              = "email"
    preferred_username = "name"
    username           = "sub"
  }

  depends_on = [aws_cognito_user_pool.this]
}

resource "aws_cognito_user_pool_client" "app" {
  name         = "${local.name_prefix}-app-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret     = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]

  callback_urls = [
    "https://${var.domain_name}",
    "https://${var.domain_name}/",
    "http://localhost:5173",
    "http://localhost:5173/",
    "https://${aws_cloudfront_distribution.this.domain_name}",
    "https://${aws_cloudfront_distribution.this.domain_name}/"
  ]

  logout_urls = [
    "https://${var.domain_name}",
    "https://${var.domain_name}/",
    "http://localhost:5173",
    "http://localhost:5173/",
    "https://${aws_cloudfront_distribution.this.domain_name}",
    "https://${aws_cloudfront_distribution.this.domain_name}/"
  ]

  access_token_validity  = 1
  id_token_validity      = 1
  refresh_token_validity = 30

  prevent_user_existence_errors = "ENABLED"

  enable_token_revocation = true

  read_attributes  = ["email", "preferred_username"]
  write_attributes = ["email", "preferred_username"]

  supported_identity_providers = ["COGNITO", "Google"]

  depends_on = [aws_cognito_identity_provider.google]
}