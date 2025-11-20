###############################################
# AWS SIEM Logging Buckets
###############################################

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "stc-cloudtrail-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket" "flowlogs_bucket" {
  bucket = "stc-flowlogs-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket" "alb_logs_bucket" {
  bucket = "stc-alb-logs-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket" "guardduty_bucket" {
  bucket = "stc-guardduty-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket" "securityhub_bucket" {
  bucket = "stc-securityhub-${var.region}"
  force_destroy = true
}
