#!/usr/bin/env bash
# sanitize.sh — Sanitize a walkthrough and publish to machines/
#
# Usage:
#   ./sanitize.sh Pterodactyl
#   ./sanitize.sh Pterodactyl --keep-flags
#   ./sanitize.sh Pterodactyl --dry-run

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SANITIZER="$PROJECT_ROOT/sanitize_walkthrough.py"
OBSIDIAN="$PROJECT_ROOT/Obsidian/HTB/Labs"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <MachineName> [--keep-flags] [--dry-run]"
    echo ""
    echo "Available machines:"
    for d in "$OBSIDIAN"/*/; do
        name="$(basename "$d")"
        [[ -f "$d/$name.md" ]] && echo "  $name"
    done
    exit 1
fi

MACHINE="$1"
shift
EXTRA_FLAGS=("$@")

WALKTHROUGH="$OBSIDIAN/$MACHINE/$MACHINE.md"
if [[ ! -f "$WALKTHROUGH" ]]; then
    echo "Error: $WALKTHROUGH not found" >&2
    exit 1
fi

# Check for --dry-run
for flag in "${EXTRA_FLAGS[@]+"${EXTRA_FLAGS[@]}"}"; do
    if [[ "$flag" == "--dry-run" ]]; then
        python3 "$SANITIZER" "$WALKTHROUGH" --dry-run
        exit 0
    fi
done

# Sanitize and output to machines/
python3 "$SANITIZER" "$WALKTHROUGH" -o "$SCRIPT_DIR/machines/" "${EXTRA_FLAGS[@]+"${EXTRA_FLAGS[@]}"}"

echo ""
echo "Published: machines/$MACHINE.md"
echo "To commit: cd $SCRIPT_DIR && git add machines/$MACHINE.md && git commit -m 'Add $MACHINE walkthrough'"
