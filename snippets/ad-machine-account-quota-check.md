---
id: ad-machine-account-quota-check
title: "Check Machine Account Quota (ms-DS-MachineAccountQuota)"
language: powershell
tags: ["Active Directory", "Autopilot", "Troubleshooting"]
prerequisites: ["ActiveDirectory PowerShell module (RSAT)", "Read access on the domain object"]
---

Reads the domain-wide `ms-DS-MachineAccountQuota` attribute — the number of computer objects a standard user is allowed to join to the domain (default: 10). A common root cause for failed Hybrid Azure AD Join / Autopilot enrollments once the quota is exhausted.

```powershell
Get-ADObject -Filter { objectClass -eq "domainDNS" } -Properties ms-DS-MachineAccountQuota |
    Select-Object -ExpandProperty ms-DS-MachineAccountQuota
```
