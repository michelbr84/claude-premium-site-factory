#!/usr/bin/env bash
set -euo pipefail

# Installer for the premium-site-factory Claude Code plugin.
# Usage: ./install.sh  (or: curl -fsSL <raw url> | bash)

MARKETPLACE_REPO="${1:-michelbr84/claude-premium-site-factory}"
MARKETPLACE_NAME="premium-site-tools"
PLUGIN_NAME="premium-site-factory"

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code CLI not found." >&2
  echo "Install it first: https://claude.com/claude-code" >&2
  exit 1
fi

echo "Adding marketplace: $MARKETPLACE_REPO"
if ! claude plugin marketplace add "$MARKETPLACE_REPO" --scope user; then
  echo "Marketplace may already exist — refreshing it instead."
  claude plugin marketplace update "$MARKETPLACE_NAME"
fi

echo "Installing plugin (user scope)..."
claude plugin install "$PLUGIN_NAME@$MARKETPLACE_NAME" --scope user

cat <<'EOF'

Installed.

Usage:
  mkdir -p ~/Projects/MyCompany-Concept
  cd ~/Projects/MyCompany-Concept
  claude

Inside Claude Code:
  /premium-site-factory:build-premium-site Create a premium website for My Company. Industry: ... CTA: ... Style: ...

If Claude Code is already open, run /reload-plugins (or restart it).
EOF
