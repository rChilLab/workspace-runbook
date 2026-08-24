---
id: igel-icg-status-check
title: "Check Igel Cloud Gateway (ICG) Connectivity"
language: powershell
tags: ["Igel ICG", "Monitoring", "Troubleshooting"]
prerequisites: ["Network access to the ICG endpoint on TCP 8443"]
---

Quick TCP/HTTPS reachability check for the Cloud Gateway — first step when remote Igel OS devices can't connect.

```powershell
$icgHost = "icg.contoso.com"
$port = 8443

$test = Test-NetConnection -ComputerName $icgHost -Port $port

[PSCustomObject]@{
    Target        = $icgHost
    Port          = $port
    TcpConnected  = $test.TcpTestSucceeded
    ResolvedIP    = $test.RemoteAddress
}
```
