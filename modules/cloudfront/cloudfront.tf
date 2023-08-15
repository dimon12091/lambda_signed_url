terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  alias  = "region"
  region = var.region
}

provider "aws" {
  region = "us-east-1"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = var.cloudfront_cache_policy_name
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = var.origin_access_control_name
  description                       = var.origin_access_control_description
  origin_access_control_origin_type = var.origin_access_control_origin_access_control_origin_type
  signing_behavior                  = var.origin_access_control_signing_behavior
  signing_protocol                  = var.origin_access_control_signing_protocol
}


resource "aws_cloudfront_distribution" "documents" {
  aliases = [aws_acm_certificate.dns.domain_name]
  origin {
    domain_name              = var.aws_s3_bucket_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
    origin_id                = var.origin_id
  }

  enabled         = var.enabled
  is_ipv6_enabled = var.is_ipv6_enabled
  comment         = var.cloudfront_distribution_comment

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.target_origin_id
    compress         = var.compress
    smooth_streaming = true

    trusted_key_groups = [
      aws_cloudfront_key_group.cf_keygroup.id
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    allowed_methods        = var.first_ordered_allowed_methods
    cached_methods         = var.first_ordered_cached_methods
    path_pattern           = var.first_ordered_path_pattern
    target_origin_id       = var.first_ordered_target_origin_id
    viewer_protocol_policy = var.first_ordered_viewer_protocol_policy
    compress               = var.first_ordered_compress
    smooth_streaming       = true

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = aws_acm_certificate.dns.domain_name # So it looks nice in the console
  }

  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.dns.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.minimum_protocol_version
  }

  depends_on = [
    aws_acm_certificate_validation.cert
  ]
}

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_cloudfront_public_key" "cf_key" {
  encoded_key = tls_private_key.keypair.public_key_pem
}

resource "aws_cloudfront_key_group" "cf_keygroup" {
  name    = var.cf_key_group_name
  comment = "Valid Document Signing Keys"
  items   = [
    aws_cloudfront_public_key.cf_key.id
  ]
}

