output "cognito_endpoint" {
  value = local.cognito_endpoint
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.main.id
}

output "alb_dns" {
  value = aws_lb.main.dns_name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.main.api_endpoint
}
