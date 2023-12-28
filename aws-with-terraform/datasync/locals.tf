locals {
  access_control_policies = [
    {
      actions = [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads"
      ]
      resources = [
        "${var.s3_source_bucket_arn}",
        "${var.s3_target_bucket_arn}"
      ]
    },
    {
      actions = [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:GetObjectTagging",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:ListMultipartUploadParts",
        "s3:PutObject",
        "s3:PutObjectTagging"
      ]
      resources = [
        "${var.s3_source_bucket_arn}/*",
        "${var.s3_target_bucket_arn}/*"
      ]
    }
  ]
}
