# static-website-hosting

- **Services:** CloudFront, S3, ACM, and Route53.
- Default region is `me-central-1 (UAE)` and ACM region is `us-east-1 (Virginia)`.
- Direct access to S3 is blocked `<BUCKET_NAME>.s3.me-central-1.amazonaws.com`.
- CloudFront can serve content to `<DOMAIN_NAME>` or `dxxxx.cloudfront.net`.
- **Remember:** ACM may take some time to issue the certificate.

```sh
cat > terraform.tfvars <<EOF
bucket_name = "<BUCKET_NAME>"
static_website_domain = "<DOMAIN_NAME>"
hosted_zone_id = "<HOSTED_ZONE_ID>"
EOF

# upload static website
aws s3 sync ./coming-soon/ s3://<BUCKET_NAME> --recursive --region me-central-1

terraform init # download plugins
terraform apply # provision

# remove
aws s3 rm s3://<BUCKET_NAME> --recursive --region me-central-1
terraform destroy
```
