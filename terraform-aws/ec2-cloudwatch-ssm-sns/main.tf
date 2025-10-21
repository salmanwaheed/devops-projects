data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "main" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "my-role-01"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  for_each = toset(local.iam_policies)

  role       = aws_iam_role.main.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "main" {
  name = "my-ip-01"
  role = aws_iam_role.main.name
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.main.id
  instance_type          = var.instance_type
  user_data              = templatefile("user-data.sh", { ssm_param_name = local.ssm_param_name })
  iam_instance_profile   = aws_iam_instance_profile.main.name
  subnet_id              = local.subnet_id
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "my-instance-01"
  }
}

resource "aws_sns_topic" "main" {
  name = "my-topic-01"
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = var.topic_subscriber_email

  confirmation_timeout_in_minutes = 5
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "my-log-group-01"
  retention_in_days = 7
  log_group_class   = upper("standard")
}

# https://github.com/aws/amazon-cloudwatch-agent
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html
resource "aws_ssm_parameter" "main" {
  name = local.ssm_param_name
  type = "String"
  value = jsonencode({
    agent = {
      metrics_collection_interval = 5
      run_as_user                 = "root"
    }
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path       = "/var/log/nginx/*.log"
              log_group_name  = aws_cloudwatch_log_group.main.name
              log_stream_name = "{instance_id}/nginx"
            },
            {
              file_path       = "/var/log/dummy-app.log"
              log_group_name  = aws_cloudwatch_log_group.main.name
              log_stream_name = "{instance_id}/dummy-app"
            }
          ]
        }
      }
    }
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html
# aws cloudwatch list-metrics --namespace "AWS/EC2"
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "my-alarm-01"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  alarm_description = "Check if instance exceeds its limit"
  alarm_actions = [
    aws_sns_topic.main.arn
  ]
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "my-error-filter-01"
  pattern        = "ERROR"
  log_group_name = aws_cloudwatch_log_group.main.name

  metric_transformation {
    name      = "ErrorCount" # metric_name
    namespace = "CustomLogs" # namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "my-alarm-02"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorCount"
  namespace           = "CustomLogs"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  alarm_description = "Alarm when the number of ERROR logs > 5"
  alarm_actions = [
    aws_sns_topic.main.arn
  ]
}
