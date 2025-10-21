# api-gateway-v2-cognito-vpc-link-alb

- **Services Used:** API Gateway v2 (HTTP_PROXY), Cognito, VPC Link, ALB, Target Group.
- **Data Sources:** Default Security Group, Subnets, VPC.
- Update `terraform.tfvars` with the required values before running Terraform.
- Configures the API to use the HTTP protocol to handle requests.
- Configures CORS to support any origin, method, or headers.
- Sets a `<TIMEOUT_MILLISECONDS>`-second timeout for requests.
- Automatically deploys changes when there are updates in the stage or integration.
- Connects to a URL based on the domain you set (e.g., `<DOMAIN>`).
- Throttling:
  - Rate Limit: Allows `<RATE_LIMIT>` requests per second.
  - Burst Limit: Allows up to `<BURST_LIMIT>` requests to handle sudden traffic spikes.
- Access Token validity is 1 hour.

```sh
terraform init # download plugins
terraform apply # provision

# get access token via OpenID Connect (OIDC) - AWS Cognito
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id <USER_POOL_CLIENT_ID> \
  --auth-parameters USERNAME=<USERNAME>,PASSWORD=<PASSWORD> \
  --region <REGION> \
  --query "AuthenticationResult.AccessToken" \
  --no-cli-pager

# OR, Use Postman
curl -X GET -H "Authorization: Bearer <TOKEN>" https://<ID>.execute-api.<REGION>.amazonaws.com/dev/
curl -X GET -H "Authorization: Bearer <TOKEN>" https://<ID>.execute-api.<REGION>.amazonaws.com/dev/products

# cleanup
terraform destroy
```
