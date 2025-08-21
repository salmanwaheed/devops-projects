output "topic_arn" {
  value = aws_sns_topic.main.arn
}

output "alb_url" {
  value = aws_lb.main.dns_name
}
