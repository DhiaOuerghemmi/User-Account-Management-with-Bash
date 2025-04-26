#!/usr/bin/env bash
source "$(dirname "$0")/../config/user_mgmt.conf"
source "$(dirname "$0")/common.sh"

threshold=$(date --date="$INACTIVE_DAYS days ago" +%s)
for user in $(awk -F: '$3>=1000{print $1}' /etc/passwd); do
  last_login=$(lastlog -u "$user" | tail -n1 | awk '{print $4, $5, $6}')
  last_ts=$(date --date="$last_login" +%s 2>/dev/null || echo 0)
  (( last_ts < threshold )) && {
    userdel -r "$user"
    log_message "Deleted inactive user $user"
  }
done

"$(dirname "$0")/send_notification.sh" "delete"
