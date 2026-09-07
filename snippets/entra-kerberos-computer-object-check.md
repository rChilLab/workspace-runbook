---
id: entra-kerberos-computer-object-check
title: "Check Azure AD Kerberos Computer Object (Hybrid Cloud Trust)"
language: powershell
tags: ["Entra ID", "Windows", "Troubleshooting"]
prerequisites: ["ActiveDirectory PowerShell module (RSAT)", "Read access to AD"]
---

Checks whether the `AzureADKerberos` computer object exists in Active Directory — this object is created by `New-AzureADKerberosServer` and is required for Windows Hello for Business Hybrid Cloud Trust / Hybrid Certificate Trust. A missing, duplicate, or stale object is a common root cause for WHfB provisioning failures.

```powershell
Get-ADComputer -Filter "Name -like 'AzureADKerberos*'" -Properties Created, whenChanged, DistinguishedName
```
