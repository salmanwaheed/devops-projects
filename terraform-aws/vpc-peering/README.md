# vpc-peering

- **Services Used:** VPC, Subnet, Route Table, VPC Peering, ENI, Network Manager (Reachability Analyzer).
- `me-central-1 (UAE)` does not support AWS Network Manager, so i am using `us-east-1 (Virginia)`
- Update `terraform.tfvars` with your variables before applying the infrastructure.
- VPC Peering DNS resolution is disabled.
- Subnets are in different Availability Zones for better testing.
- Reachability Analyzer validates VPC connectivity (`https://us-east-1.console.aws.amazon.com/networkinsights/home?region=us-east-1#ReachabilityAnalyzer`).
- ENIs are used to test connectivity without EC2 instances.

```sh
terraform init # download plugins
terraform apply # provision

# test network connectivity
export AWS_REGION=us-east-1
aws ec2 create-network-insights-path --source pcx-xxxx --destination eni-xxxx --protocol tcp
aws ec2 start-network-insights-analysis --network-insights-path-id nip-xxxx
aws ec2 describe-network-insights-analyses --network-insights-analysis-ids nia-xxxx
aws ec2 describe-network-insights-paths # get `path-id` IDs from here

# cleanup
aws ec2 delete-network-insights-analysis --network-insights-analysis-id nia-xxxx
aws ec2 delete-network-insights-path --network-insights-path-id nip-xxxx
unset AWS_REGION

terraform destroy
```
