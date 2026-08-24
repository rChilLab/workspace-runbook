---
id: spo-external-sharing-report
title: "SharePoint – External Sharing Report per Site"
language: powershell
tags: ["SharePoint", "Security", "Reporting"]
prerequisites: []
---

Overview of all SharePoint sites with external sharing enabled and their sharing capability level.

```powershell
Connect-SPOService -Url "https://contoso-admin.sharepoint.com"

Get-SPOSite -Limit All |
    Where-Object { $_.SharingCapability -ne "Disabled" } |
    Select-Object Url, SharingCapability, StorageUsageCurrent
```
