provider "aws" {
  profile = "085860729340_AdministratorAccess"
  region  = "us-east-1"
}

data "aws_eks_cluster" "this" {
  name = "eks-vpc-radar-farmarcas"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "s3" {
  source       = "./modules/s3"

  for_each = { for x in local.s3 : x.name => x }

  name_bucket  = each.value.name
  environment  = local.environment

  create_lifecycle                    = true
  rule_id                             = each.value.rule_id
  filter                              = each.value.filter
  expiration                          = each.value.expiration
  abort_incomplete_multipart_upload   = each.value.abort_incomplete_multipart_upload
  noncurrent_version_expiration       = each.value.noncurrent_version_expiration
  status_lifecycle                    = each.value.status_lifecycle

  tags = {
    Name        = each.value.name
    Environment = local.environment
    Service     = each.value.service
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
