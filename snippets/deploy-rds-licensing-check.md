---
id: deploy-rds-licensing-check
title: "Validate the RDS Licensing Server"
language: powershell
tags: ["Deployment", "RDS", "Licensing"]
prerequisites: ["Run on or against the RD Licensing server", "RDS licensing role already installed", "Firewall: dynamic TCP 135/RPC between broker and licensing server"]
---

Check the configured license server and available CALs — a common cause of 'no license server available' errors after rollout.

```powershell
Get-RDLicenseConfiguration

Get-WmiObject -Namespace "root\CIMV2\TerminalServices" -Class "Win32_TSLicenseKeyPack" |
    Select-Object ProductVersion, TotalLicenses, IssuedLicenses, KeyPackType
```
