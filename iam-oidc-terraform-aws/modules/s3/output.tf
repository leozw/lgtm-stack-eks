output "bucket-name" {
  description = "The name bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket-arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}