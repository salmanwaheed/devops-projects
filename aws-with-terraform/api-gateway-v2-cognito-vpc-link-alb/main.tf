data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "main" {
  name                       = "my-alb-01"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [data.aws_security_group.default.id]
  enable_deletion_protection = false

  dynamic "subnet_mapping" {
    for_each = data.aws_subnets.default.ids
    iterator = item

    content {
      subnet_id = item.value
    }
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = upper("http")

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = 200
      content_type = "application/json"
      message_body = jsonencode({
        name      = "Salman Waheed"
        title     = "Senior DevOps Engineer"
        location  = "Remote"
        portfolio = "https://github.com/salmanwaheed"
      })
    }
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type = "fixed-response"

    fixed_response {
      status_code  = 200
      content_type = "application/json"
      message_body = jsonencode(
        [
          { name = "Wireless Earbuds", price = 49.99, category = "Electronics" },
          { name = "Yoga Mat", price = 20.00, category = "Fitness" },
        ]
      )
    }
  }

  condition {
    path_pattern {
      values = ["/${aws_apigatewayv2_stage.main.id}/products*"]
    }
  }
}

resource "aws_cognito_user" "main" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = var.username
  password     = var.password
}

resource "aws_cognito_user_pool" "main" {
  name = "my-pool-01"

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client
resource "aws_cognito_user_pool_client" "main" {
  name         = "my-pool-client-01"
  user_pool_id = aws_cognito_user_pool.main.id

  access_token_validity  = 60 # 1 hour
  id_token_validity      = 60 # 1 hour
  refresh_token_validity = 1  # 1 day

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  explicit_auth_flows = var.explicit_auth_flows
}

resource "aws_apigatewayv2_authorizer" "main" {
  api_id           = aws_apigatewayv2_api.main.id
  name             = "jwt-auth"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.main.id]
    issuer   = local.cognito_endpoint
  }
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "my-vpc-link-01"
  subnet_ids         = data.aws_subnets.default.ids
  security_group_ids = [data.aws_security_group.default.id]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api
resource "aws_apigatewayv2_api" "main" {
  name                         = "my-apigw-01"
  protocol_type                = "HTTP"
  ip_address_type              = "ipv4"
  disable_execute_api_endpoint = false

  cors_configuration {
    max_age           = 0 # cache preflight request
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    expose_headers    = ["Access-Control-Allow-Origin"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration
resource "aws_apigatewayv2_integration" "main" {
  api_id               = aws_apigatewayv2_api.main.id
  integration_type     = "HTTP_PROXY"
  integration_method   = "ANY"
  integration_uri      = aws_lb_listener.main.arn # "https://$${stageVariables.domain}/{proxy}"
  connection_type      = "VPC_LINK"               # "INTERNET"
  connection_id        = aws_apigatewayv2_vpc_link.main.id
  timeout_milliseconds = var.timeout_milliseconds
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
resource "aws_apigatewayv2_route" "main" {
  api_id           = aws_apigatewayv2_api.main.id
  api_key_required = false
  route_key        = "ANY /{proxy+}"
  target           = "integrations/${aws_apigatewayv2_integration.main.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.main.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage
resource "aws_apigatewayv2_stage" "main" {
  api_id        = aws_apigatewayv2_api.main.id
  name          = "dev"
  auto_deploy   = false
  deployment_id = aws_apigatewayv2_deployment.main.id

  stage_variables = {
    domain = var.domain
  }

  default_route_settings {
    # logging_level = "OFF"
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    throttling_burst_limit   = var.burst_limit
    throttling_rate_limit    = var.rate_limit
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_deployment
resource "aws_apigatewayv2_deployment" "main" {
  api_id = aws_apigatewayv2_api.main.id

  triggers = {
    redeploy = sha1(jsonencode([
      aws_apigatewayv2_route.main,
      aws_apigatewayv2_integration.main,
      aws_apigatewayv2_authorizer.main,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
