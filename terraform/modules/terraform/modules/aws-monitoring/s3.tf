##################################################
# AWS Monitoring Buckets (CloudTrail + Flow Logs)
##################################################

resource "aws_s3_bucket" "cloudtrail" {
  bucket = var.cloudtrail_bucket
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "cloudtrail_versioning" {
  bucket = aws_s3_bucket.cloudtrail.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "flow_logs" {
  bucket = "stc-flowlogs-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flow_logs_sse" {
  bucket = aws_s3_bucket.flow_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
