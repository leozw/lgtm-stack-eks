resource "random_uuid" "this" {}

resource "null_resource" "helmfile_update" {
  triggers = {
    version = random_uuid.this.result
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-EOT
    ACCOUNT_ID=${data.aws_caller_identity.current.account_id}
    AWS_REGION=${data.aws_region.current.name}
    IAM_LOKI_ARN=$(terraform output -raw iam_loki_arn)
    IAM_MIMIR_ARN=$(terraform output -raw iam_mimir_arn)
    IAM_TEMPO_ARN=$(terraform output -raw iam_tempo_arn)
    S3_BUCKET_NAME_LOKI=$(terraform output -raw s3_bucket_name_loki)
    S3_BUCKET_NAME_MIMIR=$(terraform output -raw s3_bucket_name_mimir)
    S3_BUCKET_NAME_TEMPO=$(terraform output -raw s3_bucket_name_tempo)
    S3_BUCKET_NAME_MIMIR_RULER=$(terraform output -raw s3_bucket_name_mimir_ruler) 

    sed -i "s|loki-arn|$IAM_LOKI_ARN|" ../helmfile.yaml
    sed -i "/storageConfig.aws.s3/,+1 s|value: '.*'|value: 's3://$AWS_REGION/$S3_BUCKET_NAME_LOKI'|" ../helmfile.yaml
    sed -i "/storageConfig.aws.region/,+1 s|value: .*|value: $AWS_REGION|" ../helmfile.yaml
    sed -i "/storageConfig.aws.bucketnames/,+1 s|value: .*|value: $S3_BUCKET_NAME_LOKI|" ../helmfile.yaml
    
    sed -i "s|mimir-arn|$IAM_MIMIR_ARN|" ../helmfile.yaml
    sed -i "/structuredConfig.ruler_storage.s3.bucket_name/,+1 s|value: .*|value: $S3_BUCKET_NAME_MIMIR|" ../helmfile.yaml
    sed -i "/structuredConfig.ruler_storage.s3.region/,+1 s|value: .*|value: $AWS_REGION|" ../helmfile.yaml
    sed -i "/structuredConfig.blocks_storage.s3.bucket_name/,+1 s|value: .*|value: $S3_BUCKET_NAME_MIMIR_RULER|" ../helmfile.yaml

    sed -i "s|tempo-arn|$IAM_TEMPO_ARN|" ../helmfile.yaml
    sed -i "/storage.trace.s3.bucket/,+1 s|value: .*|value: $S3_BUCKET_NAME_TEMPO|" ../helmfile.yaml
    sed -i "/storage.admin.s3.bucket/,+1 s|value: .*|value: $S3_BUCKET_NAME_TEMPO|" ../helmfile.yaml

    EOT
  }

  depends_on = [
    module.s3,
    module.iam_tempo,
    module.iam_loki,
    module.iam_mimir
  ]
}
