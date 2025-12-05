resource "aws_apigatewayv2_api" "serverless_api" {
  name          = var.api_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "dynamodb_lambda" {
  api_id           = aws_apigatewayv2_api.serverless_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.invoke_dynamodb.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "s3_lambda" {
  api_id           = aws_apigatewayv2_api.serverless_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.invoke_s3.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "glue_lambda" {
  api_id           = aws_apigatewayv2_api.serverless_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.invoke_glue.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "dynamodb_lambda_route" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "ANY /invoke/dynamodb"

  target = "integrations/${aws_apigatewayv2_integration.dynamodb_lambda.id}"
}

resource "aws_apigatewayv2_route" "s3_lambda_route" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "GET /invoke/s3"

  target = "integrations/${aws_apigatewayv2_integration.s3_lambda.id}"
}

resource "aws_apigatewayv2_route" "glue_lambda_route" {
  api_id    = aws_apigatewayv2_api.serverless_api.id
  route_key = "POST /invoke/glue"

  target = "integrations/${aws_apigatewayv2_integration.glue_lambda.id}"
}

resource "aws_apigatewayv2_stage" "serverless_api_stage" {
  api_id      = aws_apigatewayv2_api.serverless_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "lambda_permission_invoke_dynamodb" {
  statement_id  = "AllowDynamoDBAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoke_dynamodb.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "lambda_permission_invoke_s3" {
  statement_id  = "AllowS3APIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoke_s3.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "lambda_permission_invoke_glue" {
  statement_id  = "AllowGlueAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoke_glue.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.serverless_api.execution_arn}/*/*/*"
}