🚀 4️⃣ Master Multi-Cloud Runner
---
#!/bin/bash
set -e

echo "====================================="
echo " SecureTheCloud – Multi-Cloud Runner "
echo "====================================="

echo "[1] Running AWS Automation..."
./automation/aws/run_lab.sh

echo "[2] Running Azure Automation..."
./automation/azure/run_lab.sh

echo "[3] Running GCP Automation..."
./automation/gcp/run_lab.sh

echo "======================================="
echo " All Multi-Cloud Labs Completed Successfully "
echo "======================================="
