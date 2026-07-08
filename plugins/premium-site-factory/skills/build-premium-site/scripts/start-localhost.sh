#!/usr/bin/env bash
set -euo pipefail

# Start the project's dev server in the background on the first free port
# starting from $1 (default 3000). Writes .local/dev.pid, .local/dev.log and
# .local/dev.url, waits until the server responds, then prints the URL.
# Run from the project root.

mkdir -p .local

START_PORT="${1:-3000}"
PORT="$START_PORT"

port_busy() {
  if command -v lsof >/dev/null 2>&1; then
    lsof -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
  elif command -v ss >/dev/null 2>&1; then
    ss -ltn 2>/dev/null | awk '{print $4}' | grep -q ":$1\$"
  else
    (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null && { exec 3>&- || true; return 0; } || return 1
  fi
}

# Reuse a server this script already started, if it is still alive.
if [ -f .local/dev.pid ] && kill -0 "$(cat .local/dev.pid)" 2>/dev/null && [ -f .local/dev.url ]; then
  echo "Server already running: $(cat .local/dev.url)"
  echo "PID: $(cat .local/dev.pid)"
  echo "Log: .local/dev.log"
  echo "Stop: kill \$(cat .local/dev.pid)"
  exit 0
fi

while port_busy "$PORT"; do
  PORT=$((PORT + 1))
  if [ "$PORT" -gt $((START_PORT + 20)) ]; then
    echo "No free port between $START_PORT and $PORT." >&2
    exit 1
  fi
done

nohup npm run dev -- --hostname 127.0.0.1 --port "$PORT" > .local/dev.log 2>&1 &
PID=$!
echo "$PID" > .local/dev.pid

URL="http://127.0.0.1:$PORT"
echo "$URL" > .local/dev.url

# Wait for the server to answer (cold start + first compile can take a while).
for _ in $(seq 1 90); do
  if ! kill -0 "$PID" 2>/dev/null; then
    echo "Dev server exited early. Last log lines:" >&2
    tail -n 25 .local/dev.log >&2
    exit 1
  fi
  if command -v curl >/dev/null 2>&1; then
    if curl -s -o /dev/null "$URL"; then
      break
    fi
  else
    break # no curl available; assume it will come up
  fi
  sleep 1
done

echo "$URL"
echo "PID: $PID"
echo "Log: .local/dev.log"
echo "Stop: kill \$(cat .local/dev.pid)"
