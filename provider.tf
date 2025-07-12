provider "aws" {
  region = "ap-northeast-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
