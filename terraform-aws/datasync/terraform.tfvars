s3_source_bucket_arn = "arn:aws:s3:::<BUCKET_NAME>"
s3_target_bucket_arn = "arn:aws:s3:::<BUCKET_NAME>"
s3_storage_class     = "standard"
task_mode            = "enhanced"

# run daily at 3pm UAE time (11am UTC)
task_schedule = "cron(0 11 * * ? *)"
# https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-cron-expressions

# ========= OPTIONAL ========= run daily at an unspecified time
# schedule = "rate(1 day)"
# https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-rate-expressions
