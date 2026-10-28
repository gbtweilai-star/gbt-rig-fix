#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_rig_fix info
PYTHONPATH=src python -m gbt_rig_fix check --payload '{}'
PYTHONPATH=src python -m gbt_rig_fix run   --payload '{}'
