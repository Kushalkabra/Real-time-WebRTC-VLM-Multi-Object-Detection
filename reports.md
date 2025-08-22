## Project Report

### Overview
This demo streams a phone camera to a laptop via WebRTC, performs on-device WASM inference in the phone browser using TensorFlow.js (wasm backend) and the COCO-SSD (lite_mobilenet_v2) model, and overlays detections on the receiver with a simple tracker. A DataChannel transports per-frame metadata with timestamps and normalized boxes.

### Architecture
- Signaling: WebSocket relay in Node/Express; rooms map peers; QR link for phone join.
- Media: Phone → RTCPeerConnection → Receiver; STUN only.
- Inference (WASM mode): tfjs-wasm on phone; 320×240 downscale; ~6–10 FPS.
- Overlay: Receiver draws on a canvas aligned to video; IoU-based track smoothing.
- Metrics: DataChannel timestamps; clock sync; HUD shows FPS/latency; metrics.json persisted via API and downloadable.
- HTTPS: localtunnel enables HTTPS URL for phone camera permissions.

### Backpressure and robustness
- Frame thinning: processing flag drops stale frames; only latest is processed every ~100 ms.
- Confidence filter: threshold 0.5 to reduce flicker; adjust higher for stability.
- Tracking: Greedy IoU matching with TTL and exponential smoothing reduces jitter.
- Recovery: Receiver waits for WS open, retries join, resets tracker on channel close. QR refresh after tunnel changes.

### Low-resource mode
- On-device WASM inference, no GPU required.
- Default 320×240 input; adjustable via UI.
- Expected CPU usage modest (depends on phone and model); FPS ~6–10 with coco-ssd lite.

### Metrics methodology
- E2E: overlay_display_ts - capture_ts after clock sync.
- Network: recv_ts - capture_ts.
- Server: inference_ts - recv_ts (WASM mode approximates phone inference time).
- FPS: displayed detections / seconds.
- Bandwidth: getStats()-derived uplink/downlink kbps.

### Sample results (WASM on modest laptop)
- median_e2e_ms ≈ 273; p95_e2e_ms ≈ 521; fps ≈ 6.1; uplink_kbps ≈ 1560; downlink_kbps ≈ 1570.
- CPU (30s average): Browser ≈ 3.2%, Container ≈ 0.2%.

### Bench script usage
The project includes headless benchmark scripts for automated metrics collection:

**Windows PowerShell:**
```powershell
./bench/run_bench.ps1 --duration 30 --mode wasm
```

**macOS/Linux:**
```bash
./bench/run_bench.sh --duration 30 --mode wasm
```

**How it works:**
1. Start the demo with phone streaming to receiver
2. Run the bench script with desired duration (default: 30s) and mode
3. Script polls `/api/metrics` endpoint every second during the run
4. After completion, saves aggregated metrics to `metrics.json` in project root
5. Output includes median/p95 E2E latency, FPS, bandwidth, and CPU usage

**Manual collection alternative:**
- Run the demo normally
- Click "Save metrics.json" button on receiver page after 30+ seconds of streaming
- Metrics are automatically downloaded and also saved server-side

### Tradeoffs and next steps
- Tradeoff: WASM for portability vs. lower FPS; improvement: server mode with quantized ONNX model (e.g., YOLOv5n) and dynamic frame rate.
- Add proper RTT-based clock sync; unify metrics to a bench script that automates collection.
- Optional TURN server for NAT traversal.


