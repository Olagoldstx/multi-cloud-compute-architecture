✅ 3. BREAK-AND-FIX VALIDATOR (cross-cloud)
---
#!/bin/bash
source automation/common/logger.sh

validate_security_basics() {

  log "Running global break-and-fix checks..."

  # Check for Terraform state drift
  terraform plan -detailed-exitcode
  if [ $? -eq 2 ]; then
      log "WARNING: Terraform drift detected."
  fi

  # Check for public IPs on VMs
  log "Checking for public IP exposure..."
  if aws ec2 describe-instances --query 'Reservations[].Instances[].PublicIpAddress' | grep -q "[0-9]"; then
      log "❌ AWS: Public IP detected!"
  fi

  if az vm list-ip-addresses --query '[].virtualMachine.network.publicIpAddresses' | grep -q "[0-9]"; then
      log "❌ Azure: Public IP detected!"
  fi

  if gcloud compute instances list --format=json | grep -q "natIP"; then
      log "❌ GCP: Public IP detected!"
  fi

  log "Security validation complete."
}
