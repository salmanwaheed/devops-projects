data "aws_caller_identity" "main" {}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["s3:GetBucketAcl"]
        Resource = ["${aws_s3_bucket.main.arn}"]
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.main.arn}/AWSLogs/${data.aws_caller_identity.main.account_id}/*"]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.main
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "cloudtrail-logs-lifecycle"
    status = "Enabled" # Disabled

    expiration {
      days = 365
    }

    filter {
      prefix = "AWSLogs/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_cloudtrail" "main" {
  name                          = "user-activity"
  s3_bucket_name                = aws_s3_bucket.main.id
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false

  depends_on = [
    aws_s3_bucket_policy.main
  ]
}
