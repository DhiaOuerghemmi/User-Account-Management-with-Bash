#!/usr/bin/env bash
source "$(dirname "$0")/../config/user_mgmt.conf"
source "$(dirname "$0")/common.sh"

TYPE=$1; CONTEXT=$2
BODY="Action: $TYPE\nContext: $CONTEXT\nSee logs: $LOG_FILE"
echo -e "$BODY" | $MAIL_CMD -s "$MAIL_SUBJECT_PREFIX $TYPE report" "$ADMIN_EMAIL"
log_message "Sent $TYPE notification to $ADMIN_EMAIL"
