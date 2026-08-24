---
id: win-eventlog-logon-failures
title: "Windows – Logon Failures from the Security Log"
language: powershell
tags: ["Windows", "Event Logs", "Troubleshooting"]
prerequisites: []
---

Read failed logons (Event 4625) from the last 24 hours, including the reason code — locally or via remote session.

```powershell
$since = (Get-Date).AddHours(-24)

Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = $since
} | Select-Object TimeCreated, @{n='User';e={$_.Properties[5].Value}}, @{n='Reason';e={$_.Properties[8].Value}}
```
