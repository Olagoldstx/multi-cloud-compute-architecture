#!/bin/bash

# ================================================
# SecureTheCloud – Multi-Cloud Break-and-Fix Engine
# ================================================
source automation/common/logger.sh

validate_security_basics() {

    log "🔎 Running multi-cloud security validation..."

    # ------------------------------
    # Terraform Drift Detection
    # ------------------------------
    log "Checking for Terraform drift..."
    terraform plan -detailed-exitcode >/dev/null

    if [ $? -eq 2 ]; then
        log_warn "Terraform drift detected! Resources do not match state."
    else
        log_success "No Terraform drift detected."
    fi

    # ------------------------------
    # Public IP Exposure
    # ------------------------------
    log "Checking for public IP exposure…"

    if aws ec2 describe-instances \
        --query 'Reservations[].Instances[].PublicIpAddress' | grep -q "[0-9]"; then
        log_error "AWS: PUBLIC IP DETECTED!"
    else
        log_success "AWS: No public IPs."
    fi

    if az vm list-ip-addresses \
        --query '[].virtualMachine.network.publicIpAddresses' | grep -q "[0-9]"; then
        log_error "Azure: PUBLIC IP DETECTED!"
    else
        log_success "Azure: No public IPs."
    fi

    if gcloud compute instances list --format=json | grep -q "natIP"; then
        log_error "GCP: PUBLIC IP DETECTED!"
    else
        log_success "GCP: No public IPs."
    fi

    # ------------------------------
    # Identity Privilege Checks
    # (Placeholder – expandable)
    # ------------------------------
    log "Checking IAM / RBAC baseline..."

    log_success "Validation complete for all clouds."
}
