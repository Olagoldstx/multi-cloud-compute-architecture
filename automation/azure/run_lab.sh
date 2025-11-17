#!/bin/bash
set -e

# ================================================
# SecureTheCloud – Azure Lab Automation Engine
# ================================================

# Load shared modules
source automation/common/logger.sh
source automation/common/backend.sh
source automation/common/validator_core.sh

MODE=$1   # deploy | destroy | plan | validate

log "================================================"
log "      SecureTheCloud – Azure Lab Automation      "
log "================================================"
log " Mode: ${MODE:-deploy}"
log "================================================"

# ------------------------------------------------
# 1. Validate Azure CLI + Login
# ------------------------------------------------
if ! command -v az &>/dev/null; then
    log_error "Azure CLI is not installed. Install Azure CLI first."
    exit 1
fi

if ! az account show &>/dev/null; then
    log_error "Azure login required. Run: az login"
    exit 1
fi

AZURE_SUB=$(az account show --query id -o tsv)
log "Authenticated to Azure Subscription: $AZURE_SUB"

# ------------------------------------------------
# 2. Navigate to Terraform Deployment Stack
# ------------------------------------------------
cd terraform/stacks/multi-cloud-deployment || {
    log_error "Terraform stack directory not found."
    exit 1
}

# ------------------------------------------------
# 3. Prepare Terraform Backend (Azure Storage)
# ------------------------------------------------
setup_backend "azure"

# ------------------------------------------------
# 4. Mode Logic
# ------------------------------------------------
case "$MODE" in

  deploy|"")
    log "Initializing Terraform..."
    terraform init -upgrade

    log "Deploying Azure VM..."
    terraform apply -target=module.azure_vm -auto-approve

    log_success "Azure VM deployment complete!"
    ;;

  destroy)
    log_warn "Destroying Azure VM resources..."
    terraform destroy -target=module.azure_vm -auto-approve
    log_success "Azure VM destroy complete!"
    ;;

  plan)
    log "Terraform plan (Azure only)…"
    terraform plan -target=module.azure_vm
    ;;

  validate)
    log "Running Azure security validation..."
    validate_security_basics
    log_success "Azure validation complete!"
    ;;

  *)
    log_error "Unknown mode: $MODE"
    log "Use: deploy | destroy | plan | validate"
    exit 1
    ;;
esac

log "================================================"
log_success "Azure Lab Execution Finished Successfully"
log "Logs saved at: $LOG_FILE"
log "================================================"
