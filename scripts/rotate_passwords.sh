#!/usr/bin/env bash
source "$(dirname "$0")/../config/user_mgmt.conf"
source "$(dirname "$0")/common.sh"

for user in $(chage -l | grep "Password expires" | awk -F: '{print $1}'); do
  last_change=$(chage -l "$user" | grep "Last password change" | cut -d: -f2)
  # Compute days since change, compare to PASS_MAX_DAYS...
  # If due, force password reset at next login:
  chage -d 0 "$user"
  log_message "Password rotation enforced for $user"
done

"$(dirname "$0")/send_notification.sh" "rotate"
