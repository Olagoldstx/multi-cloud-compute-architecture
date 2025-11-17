#!/bin/bash
set -e

# ================================================
# SecureTheCloud – GCP Lab Automation Engine
# ================================================

# Load shared modules
source automation/common/logger.sh
source automation/common/backend.sh
source automation/common/validator_core.sh

MODE=$1   # deploy | destroy | plan | validate

log "================================================"
log "       SecureTheCloud – GCP Lab Automation       "
log "================================================"
log " Mode: ${MODE:-deploy}"
log "================================================"

# ------------------------------------------------
# 1. Validate gcloud CLI + Login
# ------------------------------------------------
if ! command -v gcloud &>/dev/null; then
    log_error "gcloud CLI is not installed. Install Google Cloud SDK first."
    exit 1
fi

if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &>/dev/null; then
    log_error "GCP login required. Run: gcloud auth login"
    exit 1
fi

PROJECT_ID="caramel-pager-470614-d1"
gcloud config set project $PROJECT_ID >/dev/null

log "Authenticated to GCP Project: $PROJECT_ID"

# ------------------------------------------------
# 2. Navigate to Terraform Deployment Stack
# ------------------------------------------------
cd terraform/stacks/multi-cloud-deployment || {
    log_error "Terraform stack directory not found."
    exit 1
}

# ------------------------------------------------
# 3. Prepare Terraform Backend (GCP Bucket)
# ------------------------------------------------
setup_backend "gcp"

# ------------------------------------------------
# 4. Mode Logic
# ------------------------------------------------
case "$MODE" in

  deploy|"")
    log "Initializing Terraform..."
    terraform init -upgrade

    log "Deploying GCP Compute Engine instance..."
    terraform apply -target=module.gcp_compute -auto-approve

    log_success "GCP Compute Engine deployment complete!"
    ;;

  destroy)
    log_warn "Destroying GCP Compute Engine resources..."
    terraform destroy -target=module.gcp_compute -auto-approve
    log_success "GCP destroy complete!"
    ;;

  plan)
    log "Terraform plan (GCP only)…"
    terraform plan -target=module.gcp_compute
    ;;

  validate)
    log "Running GCP security validation..."
    validate_security_basics
    log_success "GCP validation complete!"
    ;;

  *)
    log_error "Unknown mode: $MODE"
    log "Use: deploy | destroy | plan | validate"
    exit 1
    ;;
esac

log "================================================"
log_success "GCP Lab Execution Finished Successfully"
log "Logs saved at: $LOG_FILE"
log "================================================"
