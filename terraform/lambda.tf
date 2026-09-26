data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/../lambda.zip"
}

resource "aws_lambda_function" "weather_lambda" {
  function_name = "${var.project_name}-lambda"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"
  handler = "lambda_function.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      WEATHER_API_KEY = var.weather_api_key
    }
  }
}
