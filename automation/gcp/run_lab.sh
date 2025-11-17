🚀 3️⃣ GCP Lab Automation Script
---
#!/bin/bash
set -e

echo "====================================="
echo " SecureTheCloud – GCP Lab Automation "
echo "====================================="

# Validate gcloud CLI
if ! command -v gcloud &> /dev/null
then
    echo "ERROR: gcloud CLI not installed."
    exit 1
fi

echo "[1] Checking GCP Authentication..."
gcloud auth list || { echo "GCP login required: gcloud auth login"; exit 1; }

PROJECT_ID="caramel-pager-470614-d1"

gcloud config set project $PROJECT_ID

cd terraform/stacks/multi-cloud-deployment

echo "[2] Initializing Terraform for GCP..."
terraform init -backend=false

echo "[3] Running Terraform Apply (GCP Only)..."
terraform apply -target=module.gcp_compute -auto-approve

echo "[4] GCP Deployment Complete!"
