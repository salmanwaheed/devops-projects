variable "topic_name" {}
variable "topic_subscriber_emails" { type = set(string) }
variable "budget_name" {}
variable "budget_amount" {}
variable "budget_alerts" { default = [{}] }
