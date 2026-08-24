---
id: entra-risky-users
title: "List Risky Users (Identity Protection)"
language: powershell
tags: ["Entra ID", "Security", "Risky Users"]
prerequisites: ["Graph scope: IdentityRiskyUser.Read.All", "Entra ID P2 license for Identity Protection"]
---

Retrieve all users currently flagged by Identity Protection, sorted by risk level — first stop when triaging a compromise alert.

```powershell
Get-MgRiskyUser -All |
    Where-Object { $_.RiskState -eq 'atRisk' } |
    Select-Object UserPrincipalName, RiskLevel, RiskState, RiskLastUpdatedDateTime |
    Sort-Object RiskLevel -Descending
```
