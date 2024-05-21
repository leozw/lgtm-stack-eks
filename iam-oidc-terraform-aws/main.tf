provider "aws" {
  profile = ""
  region  = ""
}

resource "random_id" "bucket_id" {
  byte_length = 8
}


data "aws_eks_cluster" "this" {
  name = "your-cluster-name"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "s3_mimir" {
  source       = "./modules/s3"
  name_bucket  = "eks-lgtm-mimir-${local.environment}-${random_id.bucket_id.hex}"
  environment  = local.environment

  create_lifecycle                    = true
  rule_id                             = local.lifecycle_rules.mimir.rule_id
  filter                              = local.lifecycle_rules.mimir.filter
  expiration                          = local.lifecycle_rules.mimir.expiration
  abort_incomplete_multipart_upload   = local.lifecycle_rules.mimir.abort_incomplete_multipart_upload
  noncurrent_version_expiration       = local.lifecycle_rules.mimir.noncurrent_version_expiration
  status_lifecycle                    = local.lifecycle_rules.mimir.status_lifecycle

  tags = {
    Name        = "eks-lgtm-mimir-${local.environment}-${random_id.bucket_id.hex}"
    Environment = local.environment
    Service     = "mimir"
  }
}

module "s3_tempo" {
  source       = "./modules/s3"
  name_bucket  = "eks-lgtm-tempo-${local.environment}-${random_id.bucket_id.hex}"
  environment  = local.environment

  create_lifecycle                    = true
  rule_id                             = local.lifecycle_rules.tempo.rule_id
  filter                              = local.lifecycle_rules.tempo.filter
  expiration                          = local.lifecycle_rules.tempo.expiration
  abort_incomplete_multipart_upload   = local.lifecycle_rules.tempo.abort_incomplete_multipart_upload
  noncurrent_version_expiration       = local.lifecycle_rules.tempo.noncurrent_version_expiration
  status_lifecycle                    = local.lifecycle_rules.tempo.status_lifecycle

  tags = {
    Name        = "eks-lgtm-tempo-${local.environment}-${random_id.bucket_id.hex}"
    Environment = local.environment
    Service     = "tempo"
  }
}

module "s3_loki" {
  source       = "./modules/s3"
  name_bucket  = "eks-lgtm-loki-${local.environment}-${random_id.bucket_id.hex}"
  environment  = local.environment

  create_lifecycle                    = true
  rule_id                             = local.lifecycle_rules.loki.rule_id
  filter                              = local.lifecycle_rules.loki.filter
  expiration                          = local.lifecycle_rules.loki.expiration
  abort_incomplete_multipart_upload   = local.lifecycle_rules.loki.abort_incomplete_multipart_upload
  noncurrent_version_expiration       = local.lifecycle_rules.loki.noncurrent_version_expiration
  status_lifecycle                    = local.lifecycle_rules.loki.status_lifecycle

  tags = {
    Name        = "eks-lgtm-loki-${local.environment}-${random_id.bucket_id.hex}"
    Environment = local.environment
    Service     = "loki"
  }
}

module "s3_mimir_ruler" {
  source       = "./modules/s3"
  name_bucket  = "eks-lgtm-mimir-ruler-${local.environment}-${random_id.bucket_id.hex}"
  environment  = local.environment

  create_lifecycle                    = true
  rule_id                             = local.lifecycle_rules.mimir.rule_id
  filter                              = local.lifecycle_rules.mimir.filter
  expiration                          = local.lifecycle_rules.mimir.expiration
  abort_incomplete_multipart_upload   = local.lifecycle_rules.mimir.abort_incomplete_multipart_upload
  noncurrent_version_expiration       = local.lifecycle_rules.mimir.noncurrent_version_expiration
  status_lifecycle                    = local.lifecycle_rules.mimir.status_lifecycle

  tags = {
    Name        = "eks-lgtm-mimir-ruler-${local.environment}-${random_id.bucket_id.hex}"
    Environment = local.environment
    Service     = "mimir-ruler"
  }
}

module "iam_loki" {
  source = "./modules/iam"

  iam_roles = {
    "loki-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "loki"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_loki
    }
  }
}

module "iam_tempo" {
  source = "./modules/iam"

  iam_roles = {
    "tempo-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "tempo"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_tempo
    }
  }
}

module "iam_mimir" {
  source = "./modules/iam"

  iam_roles = {
    "mimir-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "mimir"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_mimir
    }
  }
}
