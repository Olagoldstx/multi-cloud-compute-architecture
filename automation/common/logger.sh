#!/bin/bash

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

timestamp=$(date +"%Y%m%d-%H%M%S")
LOG_FILE="$LOG_DIR/run-$timestamp.log"

log() {
    echo "[$(date +"%H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo "[$(date +"%H:%M:%S")] SUCCESS: $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo "[$(date +"%H:%M:%S")] WARNING: $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +"%H:%M:%S")] ERROR: $1" | tee -a "$LOG_FILE"
}
