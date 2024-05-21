resource "aws_s3_bucket" "this" {
  bucket_prefix = var.name_bucket
  force_destroy = var.force_destroy

  tags = merge(
    {
      "Name"        = format("%s-%s", var.name_bucket, var.environment)
      "Platform"    = "Storage"
      "Type"        = "S3"
      "Environment" = var.environment
    },
    var.tags,
  )
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_lifecycle ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id = var.rule_id

    dynamic "abort_incomplete_multipart_upload" {
      for_each = var.abort_incomplete_multipart_upload

      content {
        days_after_initiation = lookup(abort_incomplete_multipart_upload.value, "days_after_initiation", null)
      }
    }

    dynamic "expiration" {
      for_each = var.expiration
      content {
        days = lookup(expiration.value, "days", null)
        date = lookup(expiration.value, "date", null)
      }

    }
    dynamic "filter" {
      for_each = var.filter
      content {
        prefix                   = lookup(filter.value, "prefix", null)
        object_size_greater_than = lookup(filter.value, "object_size_greater_than", null)
        object_size_less_than    = lookup(filter.value, "object_size_less_than", null)
      }

    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.noncurrent_version_expiration

      content {
        noncurrent_days = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
      }
    }

    status = var.status_lifecycle
  }
}