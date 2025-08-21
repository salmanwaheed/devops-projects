# cloudtrail-s3-lifecycle

- **Services:** CloudTrail and S3.
- CloudTrail stores logs in S3 Bucket `<BUCKET_NAME>/AWSLogs/<ACCOUNT_ID>/*`.
- First 30 days: Files stay in default `STANDARD` storage class.
- Day 30-89: Files in `STANDARD_IA`.
- Day 90-364: Files in `GLACIER`.
- Day 365+: Files are automatically deleted.

```sh
cat > terraform.tfvars <<EOF
bucket_name = "<BUCKET_NAME>"
trail_name = "<TRAIL_NAME>"
EOF

terraform init # download plugins
terraform apply # provision

 # remove
aws s3 rm s3://<BUCKET_NAME> --recursive --region me-central-1
terraform destroy
```
