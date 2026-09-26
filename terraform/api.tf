resource "aws_api_gateway_rest_api" "weather_api" {
  name = "${var.project_name}-api"
}

resource "aws_api_gateway_resource" "weather" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  parent_id   = aws_api_gateway_rest_api.weather_api.root_resource_id
  path_part   = "weather"
}

resource "aws_api_gateway_method" "weather_get" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_resource.weather.id

  http_method = "GET"

  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id
  resource_id = aws_api_gateway_resource.weather.id
  http_method = aws_api_gateway_method.weather_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = aws_lambda_function.weather_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.weather_lambda.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.weather_api.execution_arn}/*/GET/weather"
}


resource "aws_api_gateway_deployment" "weather_deployment" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.weather.id,
      aws_api_gateway_method.weather_get.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "weather_stage" {
  rest_api_id = aws_api_gateway_rest_api.weather_api.id

  deployment_id = aws_api_gateway_deployment.weather_deployment.id

  stage_name = "prod"
}
