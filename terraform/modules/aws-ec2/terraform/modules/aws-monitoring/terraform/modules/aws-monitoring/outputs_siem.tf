output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail_bucket.bucket
}

output "flowlogs_bucket" {
  value = aws_s3_bucket.flowlogs_bucket.bucket
}

output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_logs_bucket.bucket
}

output "guardduty_bucket" {
  value = aws_s3_bucket.guardduty_bucket.bucket
}

output "securityhub_bucket" {
  value = aws_s3_bucket.securityhub_bucket.bucket
}
