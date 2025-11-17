✅ 2. TERRAFORM BACKEND AUTOMATION
---
#!/bin/bash
source automation/common/logger.sh

setup_backend() {
  
  log "Configuring Terraform backend for $1..."

  case "$1" in
        
    aws)
      BUCKET="stc-terraform-backend-764265373335"
      REGION="us-east-1"
      aws s3api create-bucket --bucket $BUCKET --region $REGION --create-bucket-configuration LocationConstraint=$REGION 2>/dev/null
      log "AWS Terraform backend ready."
      ;;

    azure)
      GROUP="stc-tf-backend"
      ACCOUNT="stctfbackendacct$RANDOM"
      CONTAINER="tfstate"
      az group create -n $GROUP -l eastus >/dev/null
      az storage account create -g $GROUP -n $ACCOUNT -l eastus --sku Standard_LRS >/dev/null
      az storage container create --account-name $ACCOUNT -n $CONTAINER >/dev/null
      log "Azure Terraform backend ready."
      ;;

    gcp)
      BUCKET="stc-tf-backend-caramel-pager-470614-d1"
      gsutil mb -l us-central1 gs://$BUCKET 2>/dev/null
      log "GCP Terraform backend ready."
      ;;
  esac
}
