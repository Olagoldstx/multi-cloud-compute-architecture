#!/bin/bash

# ================================================
# SecureTheCloud – Terraform Backend Automation
# ================================================
source automation/common/logger.sh

setup_backend() {
    CLOUD="$1"

    log "Configuring Terraform backend for $CLOUD..."

    case "$CLOUD" in

        aws)
            BUCKET="stc-terraform-backend-764265373335"
            REGION="us-east-1"

            # Create bucket if it doesn't exist
            if ! aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
               log "Creating AWS S3 backend bucket: $BUCKET"
               aws s3api create-bucket \
                 --bucket $BUCKET \
                 --region $REGION \
                 --create-bucket-configuration LocationConstraint=$REGION
            else
               log "AWS backend bucket already exists."
            fi

            ;;

        azure)
            GROUP="stc-tf-backend"
            ACCOUNT="stctfbackendacct$RANDOM"
            CONTAINER="tfstate"

            log "Creating Azure backend resource group & storage..."
            az group create -n $GROUP -l eastus >/dev/null
            az storage account create -g $GROUP -n $ACCOUNT -l eastus --sku Standard_LRS >/dev/null
            az storage container create --account-name $ACCOUNT -n $CONTAINER >/dev/null

            log "Azure backend ready."

            ;;

        gcp)
            BUCKET="stc-tf-backend-caramel-pager-470614-d1"

            log "Creating GCP backend bucket (if missing)..."
            gsutil mb -l us-central1 gs://$BUCKET 2>/dev/null || \
              log "GCP bucket already exists."

            log "GCP backend ready."
            ;;
    esac

    log_success "Terraform backend configured for: $CLOUD"
}
