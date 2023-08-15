module "cloud_front" {
  source = "./modules/cloudfront"

  region                                    = var.region
  route53_zone                              = var.domain
  cert_domain_name                          = var.cert_domain_name
  aws_s3_bucket_bucket_regional_domain_name = "bucket_name.s3.amazonaws.com"
  origin_id                                 = "s3"
  enabled                                   = true
  is_ipv6_enabled                           = true
  cloudfront_distribution_comment           = "Distribution of signed S3 objects"
  allowed_methods                           = ["GET", "HEAD", "OPTIONS"] # reads only
  cached_methods                            = ["GET", "HEAD"]
  target_origin_id                          = "s3"
  compress                                  = true
  price_class                               = "PriceClass_100"
  minimum_protocol_version                  = "TLSv1.2_2021"
  cf_key_group_name                         = "cf-keygroup"

  first_ordered_allowed_methods        = ["GET", "HEAD"]
  first_ordered_cached_methods         = ["GET", "HEAD"]
  first_ordered_path_pattern           = "/*/public/*"
  first_ordered_target_origin_id       = "s3"
  first_ordered_viewer_protocol_policy = "allow-all"
  first_ordered_compress               = true

  origin_access_control_name                              = "bucket_name.s3.amazonaws.com"
  origin_access_control_description                       = "Cloudfront control for access to S3 Bucket"
  origin_access_control_origin_access_control_origin_type = "s3"
  origin_access_control_signing_behavior                  = "always"
  origin_access_control_signing_protocol                  = "sigv4"

  cloudfront_cache_policy_name = "Managed-CachingOptimized"
}