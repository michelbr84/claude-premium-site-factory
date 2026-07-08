#!/usr/bin/env bash
set -uo pipefail

# Scan the project for leaked secrets. Run from the project root.
# Prints file paths only — never the matched secret values themselves.
# Exit 1 if anything suspicious is found.

echo "Scanning for secret leaks..."
FOUND=0

# 1. Real-looking Replicate token pattern anywhere (including build output),
#    except the env files that legitimately hold it and dependencies.
LEAKS=$(grep -RIlE 'r8_[A-Za-z0-9]{20,}' . \
  --exclude-dir=node_modules --exclude-dir=.git \
  --exclude=.env.local --exclude=.env 2>/dev/null || true)
if [ -n "$LEAKS" ]; then
  echo "✗ Replicate token pattern found in:" >&2
  echo "$LEAKS" >&2
  FOUND=1
fi

# 2. No env file may be tracked by git (except .env.example).
TRACKED=$(git ls-files 2>/dev/null | grep -E '(^|/)\.env(\..+)?$' | grep -vE '\.env\.example$' || true)
if [ -n "$TRACKED" ]; then
  echo "✗ Env file tracked by git:" >&2
  echo "$TRACKED" >&2
  FOUND=1
fi

# 3. The token must never ride a browser-exposed variable name.
#    (--exclude this script: the pattern below would match itself.)
PUBLIC=$(grep -RIln 'NEXT_PUBLIC_REPLICATE\|VITE_REPLICATE' . \
  --exclude-dir=node_modules --exclude-dir=.git \
  --exclude=secret-scan.sh 2>/dev/null || true)
if [ -n "$PUBLIC" ]; then
  echo "✗ Browser-exposed Replicate variable referenced in:" >&2
  echo "$PUBLIC" >&2
  FOUND=1
fi

# 4. If .env.local holds a real token value, that exact value must appear
#    nowhere else — tracked files, build output, anywhere.
if [ -f .env.local ]; then
  TOKEN=$(sed -n 's/^REPLICATE_API_TOKEN=//p' .env.local | head -n1 | tr -d '"' | tr -d "'" | tr -d '[:space:]')
  if [ -n "$TOKEN" ] && [ "${#TOKEN}" -ge 8 ]; then
    VALUE_LEAKS=$(grep -RIl --fixed-strings "$TOKEN" . \
      --exclude-dir=node_modules --exclude-dir=.git \
      --exclude=.env.local 2>/dev/null || true)
    if [ -n "$VALUE_LEAKS" ]; then
      echo "✗ The token value from .env.local appears outside .env.local:" >&2
      echo "$VALUE_LEAKS" >&2
      FOUND=1
    fi
  fi
fi

if [ "$FOUND" -eq 1 ]; then
  echo ""
  echo "Potential secret leak found. Fix before shipping." >&2
  exit 1
fi

echo "✓ No secret leaks found."
