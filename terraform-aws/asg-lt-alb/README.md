# asg-lt-alb

- **Services Used:** Auto Scaling Group, Launch Template, EC2, Key Pair, IAM Role, CloudWatch Alarm, SNS, ALB, Target Group.
- **Data Source:** Latest AMI ID, Security Group ID, VPC ID, Subnet IDs.
- Scale-Out (add instances) is quick (3 minutes after high CPU detected).
- Scale-In (remove instances) is slower (15 minutes) for stability.
- User Data installs Nginx and injects the instance ID into the index.html for load balancer testing.
- Update `terraform.tfvars` with your variables before applying the infrastructure.
- Test load via `<ALB_URL>`.

```sh
terraform init # download plugins
terraform apply # provision

# put some load or stress out the machine
ssh -i my-key ec2-user@<ip-address>
[ec2-user@<ip-address> ~]$ stress-ng --cpu 8 --vm 1000

terraform destroy # cleanup
```
