#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Load config
source "$(dirname "$0")/../config/user_mgmt.conf"
source "$(dirname "$0")/../scripts/common.sh"

# Ensure single instance
exec 200>"$LOCKFILE"
flock -n 200 || { log_error "Another instance is running"; exit 1; }

# Parse CLI options
usage() {
  cat <<EOF
Usage: $0 [-c create] [-r rotate] [-d delete] [-h]
  -c <file>   Create users from CSV file
  -r          Rotate passwords for due accounts
  -d          Delete inactive accounts
  -h          Show help
EOF
}

while getopts ":c:rdh" opt; do
  case $opt in
    c) ACTION="create"; INPUT_FILE="$OPTARG" ;;
    r) ACTION="rotate" ;;
    d) ACTION="delete" ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

case $ACTION in
  create) "$(dirname "$0")/../scripts/create_user.sh" "$INPUT_FILE" ;;
  rotate) "$(dirname "$0")/../scripts/rotate_passwords.sh" ;;
  delete) "$(dirname "$0")/../scripts/delete_users.sh" ;;
  *) usage; exit 1 ;;
esac
