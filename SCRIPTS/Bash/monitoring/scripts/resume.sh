#!/usr/bin/env bash
# scripts/health_summary.sh
set -euo pipefail

echo "=== $(hostname) $(date) ==="
./scripts/monitor_cpu_mem.sh || true
./scripts/monitor_disk.sh || true
./scripts/monitor_ports.sh || true
./scripts/monitor_service.sh config/services.txt || true

