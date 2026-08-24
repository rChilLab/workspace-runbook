---
id: citrix-upm-logon-duration
title: "Read Citrix Profile Management Logon Duration"
language: powershell
tags: ["Citrix", "Profile Management", "Performance"]
prerequisites: ["Citrix Profile Management logging enabled (Active/Enabled in policy)"]
---

Extract profile load duration from the Citrix Profile Management event log — pinpoints slow logons caused by large profiles.

```powershell
$since = (Get-Date).AddHours(-24)

Get-WinEvent -FilterHashtable @{
    LogName   = 'Application'
    ProviderName = 'Citrix Profile management'
    StartTime = $since
} | Where-Object { $_.Message -match 'Total Profile load time' } |
    Select-Object TimeCreated, @{n='User';e={$_.UserId}}, Message
```
