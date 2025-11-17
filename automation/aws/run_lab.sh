#!/bin/bash
set -e

# ================================================
# SecureTheCloud – AWS Lab Automation Engine
# ================================================

# Load shared modules
source automation/common/logger.sh
source automation/common/backend.sh
source automation/common/validator_core.sh

MODE=$1   # deploy | destroy | plan | validate

log "=============================================="
log "     SecureTheCloud – AWS Lab Automation       "
log "=============================================="
log " Mode: ${MODE:-deploy}"
log "=============================================="

# ------------------------------------------------
# 1. Verify AWS CLI + Credentials
# ------------------------------------------------
if ! command -v aws &> /dev/null; then
    log_error "AWS CLI is not installed. Install AWS CLI first."
    exit 1
fi

if ! aws sts get-caller-identity &> /dev/null; then
    log_error "AWS credentials not set. Run: aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
log "Authenticated to AWS Account: $ACCOUNT_ID"

# ------------------------------------------------
# 2. Navigate to Terraform Deployment Stack
# ------------------------------------------------
cd terraform/stacks/multi-cloud-deployment || {
    log_error "Terraform stack directory not found."
    exit 1
}

# ------------------------------------------------
# 3. Prepare Terraform Backend (S3 bucket)
# ------------------------------------------------
setup_backend "aws"

# ------------------------------------------------
# 4. Run Mode Logic (deploy, destroy, plan, validate)
# ------------------------------------------------
case "$MODE" in

  deploy|"")
    log "Initializing Terraform for AWS..."
    terraform init -upgrade

    log "Applying AWS EC2 Deployment..."
    terraform apply -target=module.aws_ec2 -auto-approve

    log_success "AWS EC2 deployment complete!"
    ;;

  destroy)
    log_warn "Destroying AWS EC2 resources..."
    terraform destroy -target=module.aws_ec2 -auto-approve
    log_success "AWS EC2 destroy complete!"
    ;;

  plan)
    log "Terraform plan (AWS only)…"
    terraform plan -target=module.aws_ec2
    ;;

  validate)
    log "Running AWS security validation..."
    validate_security_basics
    log_success "AWS validation complete!"
    ;;

  *)
    log_error "Unknown mode: $MODE"
    log "Use: deploy | destroy | plan | validate"
    exit 1
    ;;
esac

log "=============================================="
log_success "AWS Lab Execution Finished Successfully"
log "Logs stored at: $LOG_FILE"
log "=============================================="
