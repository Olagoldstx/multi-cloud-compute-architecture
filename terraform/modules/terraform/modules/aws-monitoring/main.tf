##################################################
# SecureTheCloud — AWS Monitoring & Security Module
##################################################

###############################################
# 1. CloudTrail — account activity logging
###############################################

resource "aws_cloudtrail" "main" {
  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = var.cloudtrail_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

###############################################
# 2. GuardDuty — threat detection
###############################################

resource "aws_guardduty_detector" "main" {
  enable = true
}

###############################################
# 3. Security Hub — CIS / NIST / best practice findings
###############################################

resource "aws_securityhub_account" "main" {}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.2.0"
}

###############################################
# 4. VPC Flow Logs — network-level events
###############################################

resource "aws_flow_log" "vpc_flow" {
  vpc_id = var.vpc_id
  log_destination = var.flow_logs_bucket_arn
  traffic_type    = "ALL"
}

###############################################
# 5. CloudWatch Log Groups — metrics & application logs
###############################################

resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/stc/application"
  retention_in_days = 30
}

###############################################
# 6. ALB Access Logs — from Stage 3
###############################################

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.prefix}-alb-logs"
  acl    = "private"
}

resource "aws_lb" "alb" {
  # This data source finds your existing ALB from Stage 3
  arn = var.alb_arn

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "alb"
    enabled = true
  }
}
