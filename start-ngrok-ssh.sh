#!/bin/bash

set -e

echo "[+] Starting SSH service..."
service ssh start

# -----------------------------
# Check ngrok auth token
# -----------------------------
if [ -z "$NGROK_AUTH_TOKEN" ]; then
  echo "[!] NGROK_AUTH_TOKEN is not set!"
  echo "    export NGROK_AUTH_TOKEN=xxxxx"
  exit 1
fi

echo "[+] Configuring ngrok..."
ngrok config add-authtoken "$NGROK_AUTH_TOKEN"

# -----------------------------
# Start SSH tunnel via ngrok
# -----------------------------
echo "[+] Starting ngrok tunnel for SSH (port 22)..."

ngrok tcp 22 --log=stdout &
NGROK_PID=$!

# -----------------------------
# Keep container alive
# -----------------------------
echo "[+] Container is running..."

tail -f /dev/null
