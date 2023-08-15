output "ssm_cloudfront_public_key_id_arn" {
  value = aws_ssm_parameter.cloudfront_public_key_id.arn
}

output "ssm_cloudfront_portal_s3_private_key_arn" {
  value = aws_ssm_parameter.cloudfront_portal_s3_private_key.arn
}

output "ssm_cloudfront_public_key_id_name" {
  value = aws_ssm_parameter.cloudfront_public_key_id.name
}

output "ssm_cloudfront_portal_s3_private_key_name" {
  value = aws_ssm_parameter.cloudfront_portal_s3_private_key.name
}

output "aws_cloudfront_distribution_documents_arn" {
  value = aws_cloudfront_distribution.documents.arn
}

