# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "access_control_policy" {
  dynamic "statement" {
    for_each = local.access_control_policies
    iterator = item

    content {
      actions   = item.value.actions
      resources = item.value.resources
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "my-role-01"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "main" {
  name   = "my-acp-01"
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.access_control_policy.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_s3
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html#sc-compare
resource "aws_datasync_location_s3" "main" {
  s3_bucket_arn    = var.s3_source_bucket_arn
  subdirectory     = "/"
  s3_storage_class = upper(var.s3_storage_class)

  s3_config {
    bucket_access_role_arn = aws_iam_role.main.arn
  }
}

resource "aws_datasync_location_s3" "target" {
  provider = aws.uae

  s3_bucket_arn    = var.s3_target_bucket_arn
  subdirectory     = "/"
  s3_storage_class = upper(var.s3_storage_class)

  s3_config {
    bucket_access_role_arn = aws_iam_role.main.arn
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_task
resource "aws_datasync_task" "main" {
  name                     = "my-task-01"
  task_mode                = upper(var.task_mode)
  source_location_arn      = aws_datasync_location_s3.main.arn
  destination_location_arn = aws_datasync_location_s3.target.arn

  options {
    #### MAKE THEM "NONE", IF USING S3 BUCKET
    uid                            = "NONE"
    gid                            = "NONE"
    posix_permissions              = "NONE"
    preserve_devices               = "NONE"
    security_descriptor_copy_flags = "NONE"
    #### MAKE THEM "NONE", IF USING S3 BUCKET

    atime                  = "BEST_EFFORT"
    mtime                  = "PRESERVE"
    transfer_mode          = "CHANGED"
    verify_mode            = "ONLY_FILES_TRANSFERRED"
    bytes_per_second       = -1 # limit bandwidth usage
    preserve_deleted_files = "PRESERVE"
    overwrite_mode         = "ALWAYS"
    object_tags            = "PRESERVE"
    task_queueing          = "ENABLED"
    log_level              = "OFF"
  }

  schedule {
    schedule_expression = var.task_schedule
  }
}
