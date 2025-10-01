#!/usr/bin/env bash
# scripts/monitor_disk.sh
set -euo pipefail

THRESHOLD=${DISK_THRESHOLD:-85}
alerts=()

while read -r fs size used avail usep mount; do
  if [[ "$usep" =~ ^([0-9]+)%$ ]]; then
    val="${BASH_REMATCH[1]}"
    [[ "$val" -ge "$THRESHOLD" ]] && alerts+=("$mount:$usep")
  fi
done < <(df -hP | awk 'NR>1 {print $1, $2, $3, $4, $5, $6}')

if (( ${#alerts[@]} )); then
  msg="ALERT: Disk usage high -> ${alerts[*]}"
  echo "$msg"
  ./scripts/webhook_notify.sh "$msg"
else
  echo "Disk OK"
fi

