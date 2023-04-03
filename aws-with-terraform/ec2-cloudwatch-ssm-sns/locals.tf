locals {
  subnet_id = element(data.aws_subnets.default.ids, 1)
  iam_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  ssm_param_name = "/AmazonCloudWatch-Linux"
}
