# SSL Certificate
output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = module.acm_certificate.acm_certificate_arn
}

output "certificate_domain_validation_options" {
  description = "Domain validation options for the certificate"
  value       = module.acm_certificate.acm_certificate_domain_validation_options
}

# Network Layer
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = values(aws_subnet.private)[*].id
}

output "availability_zones" {
  description = "Availability zones used in the VPC"
  value       = local.availability_zones
}

# Security Groups
output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}


# Application Layer
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

# Network Load Balancer
output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.this.dns_name
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = aws_lb.this.arn
}

output "nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer"
  value       = aws_lb.this.zone_id
}

output "nlb_target_group_blue_arn" {
  description = "ARN of the blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "nlb_target_group_green_arn" {
  description = "ARN of the green target group"
  value       = aws_lb_target_group.green.arn
}

# CloudFront
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

# S3 Bucket
output "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  value       = aws_s3_bucket.this.bucket
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

# CI/CD Pipeline
output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.frontend.name
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.this.name
}

output "codedeploy_application_name" {
  description = "Name of the CodeDeploy application"
  value       = aws_codedeploy_app.this.name
}

output "codedeploy_deployment_group_name" {
  description = "Name of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.this.deployment_group_name
}

# Monitoring
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

# Environment Information
output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "project_name" {
  description = "Project name prefix"
  value       = local.name_prefix
}

# Cognito Authentication
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

output "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.arn
}

output "cognito_user_pool_domain" {
  description = "Domain of the Cognito User Pool"
  value       = aws_cognito_user_pool_domain.this.domain
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.app.id
}

output "cognito_hosted_ui_url" {
  description = "URL of the Cognito Hosted UI"
  value       = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${data.aws_region.current.id}.amazoncognito.com/login"
}

# API Gateway
output "api_gateway_rest_api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_gateway_url" {
  description = "Invoke URL of the API Gateway"
  value       = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${data.aws_region.current.id}.amazonaws.com/${var.environment}"
}

output "api_gateway_stage_name" {
  description = "Name of the API Gateway stage"
  value       = aws_api_gateway_stage.this.stage_name
}

output "vpc_link_id" {
  description = "ID of the VPC Link"
  value       = aws_api_gateway_vpc_link.this.id
}

output "cognito_region" {
  description = "AWS Region for Cognito"
  value       = data.aws_region.current.id
}

output "cognito_identity_provider_name" {
  description = "Name of the Google Identity Provider"
  value       = aws_cognito_identity_provider.google.provider_name
}

output "google_oauth_setup_instructions" {
  description = "Instructions for setting up Google OAuth application"
  value       = <<-EOT
    
    ========================================
    📋 GOOGLE OAUTH セットアップ手順
    ========================================
    
    1. Google Cloud Console へアクセス:
       🔗 https://console.cloud.google.com/
    
    2. プロジェクトを作成または選択:
       - "プロジェクトを選択" → "新しいプロジェクト" をクリック
       - プロジェクト名を入力し、"作成" をクリック
    
    3. Google+ API を有効化:
       - "API とサービス" → "ライブラリ" に移動
       - "Google+ API" を検索して有効化
    
    4. OAuth 2.0 認証情報を作成:
       - "API とサービス" → "認証情報" に移動
       - "認証情報を作成" → "OAuth クライアント ID" をクリック
       - "ウェブアプリケーション" を選択
    
    5. OAuth クライアントを設定:
       - 名前: "${local.name_prefix}-oauth-client"
       - 承認済みの JavaScript 生成元:
         • https://${var.domain_name}
       - 承認済みのリダイレクト URI:
         • https://${aws_cognito_user_pool_domain.this.domain}.auth.${data.aws_region.current.id}.amazoncognito.com/oauth2/idpresponse
    
    6. 認証情報をコピーして terraform.tfvars を更新:
       google_client_id = "your-google-client-id-here"
       google_client_secret = "your-google-client-secret-here"
    
    7. terraform apply を再実行して Cognito を実際の認証情報で更新
    
    ========================================
    🔧 フロントエンド設定
    ========================================
    
    example-front/.env.local を以下の値で更新:
    
    VITE_USER_POOL_ID=${aws_cognito_user_pool.this.id}
    VITE_USER_POOL_CLIENT_ID=${aws_cognito_user_pool_client.app.id}
    VITE_COGNITO_DOMAIN=${aws_cognito_user_pool_domain.this.domain}
    VITE_API_ENDPOINT=https://${var.domain_name}/api
    ========================================
  EOT
}

output "google_oauth_redirect_uri" {
  description = "Redirect URI to add to Google OAuth application"
  value       = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${data.aws_region.current.id}.amazoncognito.com/oauth2/idpresponse"
}


output "frontend_environment_variables" {
  description = "Environment variables for frontend configuration"
  value = {
    VITE_USER_POOL_ID        = aws_cognito_user_pool.this.id
    VITE_USER_POOL_CLIENT_ID = aws_cognito_user_pool_client.app.id
    VITE_COGNITO_DOMAIN      = aws_cognito_user_pool_domain.this.domain
    VITE_API_ENDPOINT        = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${data.aws_region.current.id}.amazonaws.com/${var.environment}"
  }
}

