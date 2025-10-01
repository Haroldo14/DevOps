#!/usr/bin/env bash
# scripts/monitor_cpu_mem.sh
set -euo pipefail

CPU_THRESHOLD=${CPU_THRESHOLD:-85}   # %
MEM_THRESHOLD=${MEM_THRESHOLD:-85}   # %

cpu_idle=$(mpstat 1 1 | awk '/Average/ && $12 ~ /[0-9.]+/ {print $12}')
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN {printf "%.0f", 100-idle}')
mem_usage=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

echo "CPU: ${cpu_usage}% | MEM: ${mem_usage}%"

if [[ "$cpu_usage" -ge "$CPU_THRESHOLD" || "$mem_usage" -ge "$MEM_THRESHOLD" ]]; then
  ./scripts/webhook_notify.sh "ALERT: CPU=${cpu_usage}% MEM=${mem_usage}%"
fi