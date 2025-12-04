output "http_api_endpoint" {
  value = aws_apigatewayv2_stage.serverless_api_stage.invoke_url
}