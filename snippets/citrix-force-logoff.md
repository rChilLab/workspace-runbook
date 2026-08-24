---
id: citrix-force-logoff
title: "Force Log Off a Citrix Session"
language: powershell
tags: ["Citrix", "Sessions", "Admin"]
prerequisites: []
---

End a stuck user session when reconnect or disconnect no longer works.

```powershell
$session = Get-BrokerSession -UserName "CONTOSO\jdoe"

$session | Stop-BrokerSession -LogoffTimeoutSeconds 0
```
