#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo >&2 "❌ [${BASH_SOURCE[0]}:$LINENO]: $BASH_COMMAND: exit $?"' ERR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

# Handle arguments
case "${1:-}" in
    --uninstall)
        rm -f ~/bin/xcsift
        echo "Uninstalled"
        exit 0
        ;;
esac

# Check prerequisites
command -v swift >/dev/null 2>&1 || { echo >&2 "Swift required"; exit 1; }
[[ -f "Package.swift" ]] || { echo >&2 "Wrong directory"; exit 1; }

# Build and install
swift build -c release
xattr -d com.apple.quarantine .build/release/xcsift 2>/dev/null || true

# mkdir -p ~/bin
# cp .build/release/xcsift ~/bin/
# echo "Installed to ~/bin/xcsift"

sudo cp .build/release/xcsift /usr/local/bin/
echo "Installed to /usr/local/bin"

