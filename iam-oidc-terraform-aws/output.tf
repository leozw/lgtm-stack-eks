output "s3_bucket_name_loki" {
  description = "The name of the Loki bucket"
  value       = module.s3_loki.bucket-name
}

output "s3_bucket_name_tempo" {
  description = "The name of the Tempo bucket"
  value       = module.s3_tempo.bucket-name
}

output "s3_bucket_name_mimir" {
  description = "The name of the Mimir bucket"
  value       = module.s3_mimir.bucket-name
}

output "s3_bucket_name_mimir_ruler" {
  description = "The name of the Mimir Ruler bucket"
  value       = module.s3_mimir_ruler.bucket-name
}

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
