---
id: entra-signin-logs-failed
title: "Failed Sign-Ins in the Last 24 Hours"
language: powershell
tags: ["Entra ID", "Sign-In Logs", "Troubleshooting"]
prerequisites: []
---

Retrieve failed sign-ins grouped by error code — a quick overview when troubleshooting auth issues.

```powershell
$since = (Get-Date).AddHours(-24).ToString("o")

Get-MgAuditLogSignIn -Filter "createdDateTime ge $since and status/errorCode ne 0" -All |
    Group-Object { $_.Status.ErrorCode } |
    Sort-Object Count -Descending |
    Select-Object Count, Name
```
