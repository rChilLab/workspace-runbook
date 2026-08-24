---
id: monitoring-cert-expiry-check
title: "Check Certificate Expiry on a Server"
language: powershell
tags: ["Monitoring", "Certificates", "Security"]
prerequisites: ["Local admin rights or remote access to the certificate store"]
---

List certificates in the local machine store expiring within 30 days — catches expired-cert outages before they happen.

```powershell
$days = 30
$cutoff = (Get-Date).AddDays($days)

Get-ChildItem -Path Cert:\LocalMachine\My |
    Where-Object { $_.NotAfter -lt $cutoff } |
    Select-Object Subject, NotAfter, Thumbprint |
    Sort-Object NotAfter
```
