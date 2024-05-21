locals {
  environment = "stg"

  s3 = [
    {
      name    = "eks-lgtm-mimir-${local.environment}-"
      rule_id = "jobs/cachePath-${local.environment}-mimir"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = 1
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
      service          = "mimir"
    },
    {
      name    = "eks-lgtm-mimir-ruler-${local.environment}-"
      rule_id = "jobs/cachePath-${local.environment}-mimir-ruler"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = 1
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
      service          = "mimir-ruler"
    },
    {
      name    = "eks-lgtm-tempo-${local.environment}-"
      rule_id = "jobs/cachePath-${local.environment}-tempo"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = 1
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
      service          = "tempo"
    },
    {
      name    = "eks-lgtm-loki-${local.environment}-"
      rule_id = "jobs/cachePath-${local.environment}-loki"
      filter = {
        "prefix" = {
          "prefix" = ""
        }
      }
      expiration = {
        "days" = {
          "days" = 1
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
      service          = "loki"
    }
  ]

  policy_arn_mimir = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket", "s3:GetBucketLocation"],
        Resource = [
          "${[for v in module.s3 : v.bucket-arn][1]}",
          "${[for v in module.s3 : v.bucket-arn][2]}"
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
          "${[for v in module.s3 : v.bucket-arn][1]}/*",
          "${[for v in module.s3 : v.bucket-arn][2]}/*"
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
          "${[for v in module.s3 : v.bucket-arn][3]}"
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
          "${[for v in module.s3 : v.bucket-arn][3]}/*"
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
          "${[for v in module.s3 : v.bucket-arn][3]}"
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
          "${[for v in module.s3 : v.bucket-arn][3]}/*"
        ],
      },
    ],
  })
}
