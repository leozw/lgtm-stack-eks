output "arn" {
  description = "Output IAM role ARNs"
  value       = [for v in aws_iam_role.this : v.arn]
}