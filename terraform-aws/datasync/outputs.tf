output "s3_location_arns" {
  value = {
    source = aws_datasync_location_s3.main.arn
    target = aws_datasync_location_s3.target.arn
  }
}

output "task_arn" {
  value = aws_datasync_task.main.arn
}
