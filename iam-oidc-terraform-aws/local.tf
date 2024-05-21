locals {
  environment = "prd"

  retention_rules = {
    loki = {
      "dev"  = 1
      "qa"   = 1
      "pprd" = 1
      "prd"  = null
    }
    mimir = {
      "dev"  = 7
      "qa"   = 14
      "pprd" = 30
      "prd"  = 90
    }
    tempo = {
      "dev"  = 3
      "qa"   = 3
      "pprd" = 7
      "prd"  = 7
    }
  }

  lifecycle_rules = {
    loki = {
      rule_id = "jobs/cachePath-${local.environment}-loki"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = local.retention_rules.loki[local.environment]
        }
      }
      abort_incomplete_multipart_upload = {
        "days_after_initiation" = {
          "days_after_initiation" = 1
        }
      }
      noncurrent_version_expiration = {
        "noncurrent_days" = {
          "noncurrent_days" = 1
        }
      }
      status_lifecycle = local.environment == "prd" ? "Disabled" : "Enabled"
    }
    mimir = {
      rule_id = "jobs/cachePath-${local.environment}-mimir"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = local.retention_rules.mimir[local.environment]
        }
      }
      abort_incomplete_multipart_upload = {
        "days_after_initiation" = {
          "days_after_initiation" = 1
        }
      }
      noncurrent_version_expiration = {
        "noncurrent_days" = {
          "noncurrent_days" = 1
        }
      }
      status_lifecycle = "Enabled"
    }
    tempo = {
      rule_id = "jobs/cachePath-${local.environment}-tempo"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = local.retention_rules.tempo[local.environment]
        }
      }
      abort_incomplete_multipart_upload = {
        "days_after_initiation" = {
          "days_after_initiation" = 1
        }
      }
      noncurrent_version_expiration = {
        "noncurrent_days" = {
          "noncurrent_days" = 1
        }
      }
      status_lifecycle = "Enabled"
    }
  }
}
locals {
  policy_arn_mimir = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket", "s3:GetBucketLocation"],
        Resource = [
          "${module.s3_mimir_ruler.bucket-arn}",
          "${module.s3_mimir.bucket-arn}"
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
        ],
        Resource = [
          "${module.s3_mimir_ruler.bucket-arn}/*",
          "${module.s3_mimir.bucket-arn}/*"
        ],
      },
    ],
  })
  policy_arn_tempo = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket", "s3:GetBucketLocation"],
        Resource = [
          "${module.s3_tempo.bucket-arn}"
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
        ],
        Resource = [
          "${module.s3_tempo.bucket-arn}/*"
        ],
      },
    ],
  })

  policy_arn_loki = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket", "s3:GetBucketLocation"],
        Resource = [
          "${module.s3_loki.bucket-arn}"
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
        ],
        Resource = [
          "${module.s3_loki.bucket-arn}/*"
        ],
      },
    ],
  })
}
