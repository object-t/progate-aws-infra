resource "aws_s3_bucket" "this" {
  bucket        = "${local.name_prefix}-frontend-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}



resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.name_prefix}-frontend-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  description                       = "Origin Access Control for ${local.name_prefix}-frontend-bucket"
}


resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "${local.name_prefix}-frontend-distribution"
  default_root_object = "index.html"

  # S3 Origin for static content
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = "S3-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Default behavior - serve static content from S3
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}