# ec2-cloudwatch-ssm-sns

- **Services Used:** EC2, Key Pair, CloudWatch {Alarms, Logs, Filters}, Parameter Store, SNS.
- **Data Source:** Latest AMI ID, Security Group ID, VPC ID, Subnet ID.
- Update `terraform.tfvars` with your variables before applying the infrastructure.
- Associates a custom IAM Role and Instance Profile with the EC2 instance.
- Deploys the AWS CloudWatch Agent configuration using the SSM Parameter Store.
- Gathers logs from `/var/log/nginx/*.log` and `/var/log/dummy-app.log`.
- Creates a CloudWatch alarm for CPUUtilization > `10%` and sends an email notification.
- Configures a log filter to detect if `ERROR` logs exceed `5` occurrences and triggers an email notification.

```sh
terraform init # download plugins
terraform apply # provision

# this package is required to use SSM sessions, install it if it's not already installed.
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
session-manager-plugin --version
aws ssm start-session --target <INSTANCE_ID> --region me-central-1

sh-5.2$ sudo su ec2-user
[ec2-user@<ip-address> bin]$ cd
[ec2-user@<ip-address> ~]$ tail -n 100 -f /var/log/amazon/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log
# test, add fake logs
[ec2-user@<ip-address> ~]$ seq 1 3 | xargs -I{} -n1 echo "ERROR Testing CloudWatch Alarm 0{} by Salman" | sudo tree -a /var/log/dummy-app.log
# test, stress out the machine to check alarm
[ec2-user@<ip-address> ~]$ stress-ng --cpu 8 --vm 1000

terraform destroy # cleanup
```
