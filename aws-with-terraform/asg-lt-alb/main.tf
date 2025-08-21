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
    name   = "description"
    values = ["Amazon Linux 2023 AMI 2023.* x86_64 HVM kernel*"] # Amazon Linux 2023 AMI 2023.7.20250414.0 x86_64 HVM kernel-6.1
  }
}

resource "aws_iam_role" "main" {
  name = "my-role-01"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "main" {
  name = "my-ip-01"
  role = aws_iam_role.main.name
}

# ssh-keygen -t rsa -b 4096 -f ./my-key
resource "aws_key_pair" "main" {
  key_name   = "my-key-01"
  public_key = file("./my-key.pub")
}

resource "aws_launch_template" "main" {
  name                   = "my-lt-01"
  image_id               = data.aws_ami.main.id
  instance_type          = "t3.nano"
  key_name               = aws_key_pair.main.key_name
  update_default_version = true
  ebs_optimized          = true
  user_data              = filebase64("./user-data.sh")

  placement {
    # availability_zone = "me-central-1a"
    tenancy = "default"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_type           = "gp2"
      volume_size           = 8
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "none"
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    network_card_index          = 0
    security_groups             = [data.aws_security_group.default.id]
  }

  credit_specification {
    cpu_credits = "standard"
  }

  monitoring {
    enabled = false
  }

  metadata_options {
    http_tokens = "required"
  }

  # tag_specifications {}
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "main" {
  name                      = "my-asg-01"
  desired_capacity_type     = "units"
  desired_capacity          = var.desired_capacity # start instance immediately
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = data.aws_subnets.default.ids
  default_cooldown          = 60
  health_check_grace_period = 60
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.main.arn]

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  launch_template {
    name    = aws_launch_template.main.name
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "my-asg-01"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "main" {
  enabled                = true
  autoscaling_group_name = aws_autoscaling_group.main.name
  name                   = "scale-in-out-policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    disable_scale_in = false # remove instances, if < 80%
    target_value     = var.scaling_target_value

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }

  depends_on = [
    aws_autoscaling_group.main
  ]
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

# https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_NotificationConfiguration.html
resource "aws_autoscaling_notification" "main" {
  topic_arn   = aws_sns_topic.main.arn
  group_names = [aws_autoscaling_group.main.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}

resource "aws_lb" "main" {
  name                       = "my-alb-01"
  ip_address_type            = "ipv4"
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
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.main.arn
        weight = 1
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "main" {
  name             = "my-tg-01"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = data.aws_vpc.default.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = 200
  }
}
