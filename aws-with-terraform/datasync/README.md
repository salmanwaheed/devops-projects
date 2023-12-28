# datasync

- **Services Used:** S3, DataSync, IAM Role, IAM Inline Policy.
- **Data Sources:** IAM Policy Document.
- Create S3 Buckets and update `terraform.tfvars` with the required values before running Terraform.
- S3 Buckets are located in: Source - `eu-west-1` (Ireland), Destination - `me-central-1` (UAE).
- Task runs automatically every day at 3:00 PM UAE time (11:00 AM UTC).
- Test the sync by uploading random images from `https://picsum.photos/1200/800` to the source bucket.

```sh
aws s3 mb s3://<BUCKET_NAME> --region eu-west-1 # source bucket
aws s3 mb s3://<BUCKET_NAME> --region me-central-1 # destination bucket
aws s3 sync /path/to/random-images s3://<BUCKET_NAME> --region eu-west-1 # upload images into source bucket

terraform init # download plugins
terraform apply # provision

# cleanup
aws s3 rb s3://<BUCKET_NAME> --force --region eu-west-1
aws s3 rb s3://<BUCKET_NAME> --force --region me-central-1

terraform destroy
```
