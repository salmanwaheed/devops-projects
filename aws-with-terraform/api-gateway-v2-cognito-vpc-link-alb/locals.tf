locals {
  cognito_endpoint = "https://${aws_cognito_user_pool.main.endpoint}"
}
