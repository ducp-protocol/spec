#!/usr/bin/env bash
# Clone or update DUCP sibling repos next to this spec checkout.
# Usage: ./scripts/setup-workspace.sh [WORKSPACE_ROOT]
# Default WORKSPACE_ROOT: parent of the spec repo directory (../ from spec root).

set -euo pipefail

SPEC_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE_ROOT="${1:-$(dirname "$SPEC_ROOT")}"

NODE_DIR="$WORKSPACE_ROOT/ducp-node-rs"
PROFILE_DIR="$WORKSPACE_ROOT/org-profile"

clone_or_pull() {
  local url="$1"
  local dir="$2"
  if [[ -d "$dir/.git" ]]; then
    echo "==> pull $dir"
    git -C "$dir" pull --rebase
  else
    echo "==> clone $url -> $dir"
    git clone "$url" "$dir"
  fi
}

mkdir -p "$WORKSPACE_ROOT"

if [[ "$(cd "$SPEC_ROOT" && pwd)" != "$(cd "$WORKSPACE_ROOT/spec" 2>/dev/null && pwd)" ]]; then
  echo "Note: spec repo is at $SPEC_ROOT (expected sibling layout under $WORKSPACE_ROOT/spec)."
  echo "      Rename or re-clone to DUCP/spec for the canonical layout — see WORKSPACE.md."
fi

clone_or_pull git@github.com:ducp-protocol/ducp-node-rs.git "$NODE_DIR"
clone_or_pull git@github.com:ducp-protocol/.github.git "$PROFILE_DIR"

echo ""
echo "Workspace ready under $WORKSPACE_ROOT"
echo "  spec/          -> $SPEC_ROOT"
echo "  ducp-node-rs/  -> $NODE_DIR"
echo "  org-profile/   -> $PROFILE_DIR"
echo ""
echo "Open $WORKSPACE_ROOT in your editor."
