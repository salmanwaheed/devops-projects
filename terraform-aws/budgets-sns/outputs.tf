output "topic_arn" {
  value = aws_sns_topic.main.arn
}

output "budget_arn" {
  value = aws_budgets_budget.main.arn
}
