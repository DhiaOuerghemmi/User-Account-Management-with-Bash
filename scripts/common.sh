#!/usr/bin/env bash
# Logging setup
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%F)_user_mgmt.log"

log_message() {
  echo "$(date '+%F %T') - INFO - $1" | tee -a "$LOG_FILE"
}
log_error() {
  echo "$(date '+%F %T') - ERROR - $1" | tee -a "$LOG_FILE" >&2
}

# Input validation
validate_username() {
  [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]] || {
    log_error "Invalid username: $1"; return 1
  }
}
