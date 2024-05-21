output "iam_mimir_arn" {
  description = "Output IAM ARN for Mimir"
  value       = module.iam_mimir.arn[0]
}

output "iam_tempo_arn" {
  description = "Output IAM ARN for Tempo"
  value       = module.iam_tempo.arn[0]
}

output "iam_loki_arn" {
  description = "Output IAM ARN for Loki"
  value       = module.iam_loki.arn[0]
}

output "s3_bucket_name_loki" {
  description = "The name of the Loki bucket"
  value       = [for v in module.s3 : v.bucket-arn][0]
}

output "s3_bucket_name_mimir_ruler" {
  description = "The name of the Loki bucket"
  value       = [for v in module.s3 : v.bucket-arn][1]
}

output "s3_bucket_name_mimir" {
  description = "The name of the Loki bucket"
  value       = [for v in module.s3 : v.bucket-arn][2]
}

output "s3_bucket_name_tempo" {
  description = "The name of the Loki bucket"
  value       = [for v in module.s3 : v.bucket-arn][3]
}

