resource "aws_sns_topic" "main" {
  name = var.topic_name
}

resource "aws_sns_topic_subscription" "main" {
  for_each = var.topic_subscriber_emails

  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = each.value

  confirmation_timeout_in_minutes = 5
}

resource "aws_budgets_budget" "main" {
  name         = var.budget_name
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = var.budget_amount
  limit_unit   = "USD"

  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true # Marketplace or third-party
    include_recurring          = true
    include_refund             = false # track real spend
    include_subscription       = true  # RDS, ec2, s3 storage, etc.
    include_support            = true  # aws support charges
    include_tax                = true
    include_upfront            = true  # Reserved Instance upfront
    use_amortized              = false # Reserved Instances
    use_blended                = false
  }

  dynamic "notification" {
    for_each = var.budget_alerts
    iterator = item

    content {
      comparison_operator       = lookup(item.value, "comparison_operator", "GREATER_THAN")
      notification_type         = lookup(item.value, "notification_type", "ACTUAL")
      threshold_type            = lookup(item.value, "threshold_type", "PERCENTAGE")
      threshold                 = lookup(item.value, "threshold", "80")
      subscriber_sns_topic_arns = [aws_sns_topic.main.arn] # alerts via email, lambda, etc.
      # subscriber_email_addresses = var.topic_subscriber_emails # alerts via email
    }
  }
}
