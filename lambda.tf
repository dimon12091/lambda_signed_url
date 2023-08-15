data "archive_file" "lambda_signed_url" {
  type        = "zip"
  source_dir = "${path.module}/package"
  output_path = "${path.module}/package.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "signed_url_lambda"

  filename         = data.archive_file.lambda_signed_url.output_path
  source_code_hash = data.archive_file.lambda_signed_url.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = "180"
  environment {
    variables = {
      KEY_KEY_ID      = module.cloud_front.ssm_cloudfront_public_key_id_name
      KEY_PRIVATE_KEY = module.cloud_front.ssm_cloudfront_portal_s3_private_key_name
    }
  }
}

## API Gateway
#resource "aws_apigatewayv2_api" "api_signed_url" {
#  name          = "${var.env_name}-api-signed-url"
#  protocol_type = "HTTP"
#  target        = aws_lambda_function.lambda.arn
#}
#
#resource "aws_lambda_permission" "apigw_signed_url" {
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.lambda.arn
#  principal     = "apigateway.amazonaws.com"
#
#  source_arn = "${aws_apigatewayv2_api.api_signed_url.execution_arn}/*/*"
#}