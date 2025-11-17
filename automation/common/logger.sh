✅ 1. LOGGING SYSTEM (shared module)
---
#!/bin/bash

LOG_DIR="logs"
mkdir -p $LOG_DIR

timestamp=$(date +"%Y%m%d-%H%M%S")
LOG_FILE="$LOG_DIR/run-$timestamp.log"

log() {
    echo "[$(date +"%H:%M:%S")] $1" | tee -a $LOG_FILE
}
