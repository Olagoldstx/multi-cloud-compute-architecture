#!/bin/bash
set -e

echo "====================================="
echo " SecureTheCloud – AWS Lab Automation "
echo "====================================="

# Validate AWS CLI
if ! command -v aws &> /dev/null
then
    echo "ERROR: aws CLI not installed."
    exit 1
fi

echo "[1] Checking AWS Caller Identity..."
aws sts get-caller-identity || { echo "AWS credentials not configured."; exit 1; }

cd terraform/stacks/multi-cloud-deployment

echo "[2] Initializing Terraform for AWS..."
terraform init -backend=false

echo "[3] Running Terraform Apply (AWS Only)..."
terraform apply -target=module.aws_ec2 -auto-approve

echo "[4] AWS Deployment Complete!"
