#!/usr/bin/env bash
source "$(dirname "$0")/../config/user_mgmt.conf"
source "$(dirname "$0")/common.sh"

INPUT_FILE=${1:-}W
[[ -f "$INPUT_FILE" ]] || { log_error "Input file missing"; exit 1; }

while IFS=, read -r username groups; do
  validate_username "$username" || continue
  if id "$username" &>/dev/null; then
    log_message "User $username exists; skipping"
  else
    useradd -m "$username" && log_message "Created $username"
    echo "$username:$(openssl rand -base64 12)" | chpasswd
    log_message "Set initial password for $username"
  fi
  # Assign to groups
  for g in ${groups//;/ }; do
    groupadd -f "$g"
    usermod -aG "$g" "$username"
  done
done < "$INPUT_FILE"

# Notify admin
"$(dirname "$0")/send_notification.sh" "create" "$INPUT_FILE"
