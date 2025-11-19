output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "guardduty_id" {
  value = aws_guardduty_detector.main.id
}
