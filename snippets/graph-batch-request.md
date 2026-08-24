---
id: graph-batch-request
title: "Graph Batch Request (Bundle Multiple Calls)"
language: powershell
tags: ["Graph", "Performance", "Batch"]
prerequisites: []
---

Bundle multiple Graph requests into a single HTTP call — reduces throttling risk on many individual queries.

```powershell
$batch = @{
    requests = @(
        @{ id = "1"; method = "GET"; url = "/users/{id1}" }
        @{ id = "2"; method = "GET"; url = "/users/{id2}" }
    )
} | ConvertTo-Json -Depth 5

Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/`$batch" -Body $batch
```
