---
id: deploy-rds-add-sessionhost
title: "Add an RDS Session Host to a Collection"
language: powershell
tags: ["Deployment", "RDS", "Session Host"]
prerequisites: ["Server already has the RDSH role installed", "Run from the RD Connection Broker", "Domain admin or delegated RDS admin rights", "Firewall: TCP 3389 (RDP) and dynamic TCP 135/RPC between broker and session host"]
---

Assign a new session host server to an existing RDS collection and validate farm membership.

```powershell
Import-Module RemoteDesktop

$collection = "Prod-Collection-01"
$newHost = "RDSH-05.contoso.local"

Add-RDSessionHost -CollectionName $collection -SessionHost $newHost

Get-RDSessionHost -CollectionName $collection |
    Select-Object SessionHost, NewConnectionAllowed
```
