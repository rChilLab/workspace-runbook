---
id: powershell-get-service
title: "Get Service StartType"
language: powershell
tags: ["Citrix", "Admin","Microsoft"]
prerequisites: []
---

End a stuck user session when reconnect or disconnect no longer works.

```powershell
Get-Service | select -property name,starttype
```
