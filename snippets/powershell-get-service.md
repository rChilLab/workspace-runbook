---
id: powershell-get-service
title: "Get Service StartType"
language: powershell
tags: ["Citrix", "Admin","Microsoft"]
prerequisites: []
---

Check which status has got the Service you need

```powershell
Get-Service <ServiceName> | select -property name,starttype
```
