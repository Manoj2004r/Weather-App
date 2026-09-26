output "lambda_function_name" {
  value = aws_lambda_function.weather_lambda.function_name
}

output "api_gateway_url" {
  value = "${aws_api_gateway_stage.weather_stage.invoke_url}/weather"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.frontend.website_endpoint
}
