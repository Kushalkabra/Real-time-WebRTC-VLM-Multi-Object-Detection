$ErrorActionPreference = "Stop"

# Parse command line arguments
$duration = 30
$mode = "wasm"

if ($args.Count -ge 1) {
    $duration = [int]$args[0]
}
if ($args.Count -ge 2) {
    $mode = $args[1]
}

Write-Host "Waiting $duration seconds to collect metrics for mode: $mode"
Start-Sleep -Seconds $duration

try {
    $resp = Invoke-WebRequest -UseBasicParsing http://localhost:3000/api/metrics
    if ($resp.StatusCode -eq 200) {
        $json = $resp.Content | ConvertFrom-Json
        $json | ConvertTo-Json -Depth 5 | Out-File -Encoding UTF8 metrics.json
        Write-Host "Saved metrics.json"
    } else {
        Write-Host "No metrics available (status $($resp.StatusCode))"
    }
} catch {
    Write-Host "Failed to fetch metrics: $_"
}


