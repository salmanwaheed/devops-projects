# budgets-sns

- **Services Used:** AWS Budgets and SNS.
- Create an AWS Cost Budget (e.g., `<BUDGET_AMOUNT> USD` per month).
- Send alerts via SNS if the cost exceeds a certain percentage (e.g., `<THRESHOLD>`%).
- `email` protocol requires manual confirmation from your inbox.
- Support custom cost types and alert settings (optional).
- Update `terraform.tfvars` with your variables before applying the infrastructure.

```sh
terraform init # download plugins
terraform apply # provision
terraform destroy # cleanup
```
