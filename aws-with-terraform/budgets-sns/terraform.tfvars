topic_name              = "<TOPIC_NAME>"
topic_subscriber_emails = ["<EMAIL_1>", "<EMAIL_2>"]

budget_name   = "<BUDGET_NAME>"
budget_amount = "<BUDGET_AMOUNT>"

# get values from this url
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget#budget-notification
# if budget_alerts = [], no alerts will be created.
# if budget_alerts = [{}], default values will be used to create alerts.
budget_alerts = [
  {
    comparison_operator = "EQUAL_TO" # "GREATER_THAN" is default value
    # notification_type   = "ACTUAL"     # default value
    # threshold_type      = "PERCENTAGE" # default value
    # threshold           = 80           # default value
  },
  {
    # if not provided, use default values
    threshold = "<THRESHOLD>"
  }
]
