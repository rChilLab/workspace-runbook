---
id: powershell-services
title: "Service Configuration StartType"
language: powershell
tags: ["Citrix", "Admin","Microsoft"]
prerequisites: []
---

Check which status has got the Service you need

```powershell
Get-Service <Name> | select -property name,starttype

Set-Service <Name> -StartupType Automatic
```
