#!/bin/bash

export AWS_PROFILE=securethecloud
AWS_REGION="us-east-1"

echo "===================="
echo " Syncing AWS Logs..."
echo "===================="

echo "[1] CloudTrail..."
aws s3 sync s3://stc-cloudtrail-${AWS_REGION} ./cloudtrail --exclude "*" --include "*.json"

echo "[2] VPC Flow Logs..."
aws s3 sync s3://stc-flowlogs-${AWS_REGION} ./vpc-flow --exclude "*" --include "*.log"

echo "[3] ALB Access Logs..."
aws s3 sync s3://stc-alb-logs-${AWS_REGION} ./alb --exclude "*" --include "*.log"

echo "[4] GuardDuty..."
aws s3 sync s3://stc-guardduty-${AWS_REGION} ./guardduty

echo "[5] SecurityHub..."
aws s3 sync s3://stc-securityhub-${AWS_REGION} ./securityhub

echo "===================="
echo " Sync complete."
echo "===================="
