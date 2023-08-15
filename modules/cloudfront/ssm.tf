resource "random_id" "id" {
  byte_length = 8
}

resource "aws_ssm_parameter" "cloudfront_portal_s3_private_key" {
  provider = aws.region
  name  = "${random_id.id.hex}-cloudfront-private-key"
  type  = "SecureString"
  value = tls_private_key.keypair.private_key_pem
}

resource "aws_ssm_parameter" "cloudfront_public_key_id" {
  provider = aws.region
  name  = "${random_id.id.hex}-cloudfront-public-key-id"
  type  = "SecureString"
  value = aws_cloudfront_public_key.cf_key.id
}