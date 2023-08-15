variable "region" {}
variable "route53_zone" {}
variable "cert_domain_name" {}
variable "aws_s3_bucket_bucket_regional_domain_name" {}
variable "origin_id" {}
variable "enabled" {}
variable "is_ipv6_enabled" {}
variable "cloudfront_distribution_comment" {}
variable "allowed_methods" {}
variable "cached_methods" {}
variable "target_origin_id" {}
variable "compress" {}
variable "price_class" {}
variable "minimum_protocol_version" {}
variable "cf_key_group_name" {}

variable "first_ordered_allowed_methods" {}
variable "first_ordered_cached_methods" {}
variable "first_ordered_path_pattern" {}
variable "first_ordered_target_origin_id" {}
variable "first_ordered_viewer_protocol_policy" {}
variable "first_ordered_compress" {}

variable "origin_access_control_name" {}
variable "origin_access_control_description" {}
variable "origin_access_control_origin_access_control_origin_type" {}
variable "origin_access_control_signing_behavior" {}
variable "origin_access_control_signing_protocol" {}

variable "cloudfront_cache_policy_name" {}