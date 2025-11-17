🚀 2️⃣ AZURE Lab Automation Script
---
#!/bin/bash
set -e

echo "======================================"
echo " SecureTheCloud – Azure Lab Automation "
echo "======================================"

# Validate AZ CLI
if ! command -v az &> /dev/null
then
    echo "ERROR: Azure CLI not installed."
    exit 1
fi

echo "[1] Checking Azure Account..."
az account show || { echo "Azure login required: az login"; exit 1; }

cd terraform/stacks/multi-cloud-deployment

echo "[2] Initializing Terraform for Azure..."
terraform init -backend=false

echo "[3] Running Terraform Apply (Azure Only)..."
terraform apply -target=module.azure_vm -auto-approve

echo "[4] Azure Deployment Complete!"
