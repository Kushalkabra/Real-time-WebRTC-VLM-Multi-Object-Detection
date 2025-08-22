## Real-time WebRTC VLM Multi-Object Detection

Phone → Browser (WebRTC) → On-device WASM inference → Overlay + metrics.

### One-command run

- Windows (PowerShell):

```bash
./start.ps1
```

- macOS/Linux:

```bash
./start.sh
```

If Docker is installed, it uses docker-compose up --build. Otherwise it runs npm start locally.
Defaults: MODE=wasm, HTTPS tunnel enabled for phone camera permissions.

### Run the demo (phone → browser)

1. Open http://localhost:3000 on your laptop.
2. Click "Create Room".
3. Scan the QR with your phone. The link is HTTPS via tunnel.
   - If you see a password page (from the HTTPS tunnel), scroll down a little and tap the link to reveal the password. Copy the shown password, then paste it to proceed to the Phone Publisher page.
4. On the phone ,choose which camera you want to use and then tap "Start Camera" and allow camera.
5. You should see overlays on laptop with labels and a live metrics HUD (FPS, latency, kbps).

Tip: After rebuilds, the tunnel URL changes. Always use the latest QR/link.

### Mode switch
- Windows PowerShell:
  - WASM (default, low-resource): `$env:MODE="wasm"; ./start.ps1`
  - Server (placeholder): `$env:MODE="server"; ./start.ps1`
- macOS/Linux (bash/zsh):
  - WASM (default, low-resource): `MODE=wasm ./start.sh`
  - Server (placeholder): `MODE=server ./start.sh` – gateway is the same, inference off by default (ready for future server inference integration).

### Metrics and bench
- Headless bench scripts are included; see `reports.md` for metrics methodology, samples, and how to collect.

### Troubleshooting
- If phone won’t connect: ensure same Wi‑Fi OR use the HTTPS link shown (tunnel)
- After rebuilds, the `*.loca.lt` URL changes; re-scan the new QR
- Negative latencies? Reload; clock sync runs on DataChannel open
- High CPU? Switch to 320×240 (qvga) and keep detection enabled in WASM mode




