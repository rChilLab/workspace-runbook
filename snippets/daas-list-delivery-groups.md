---
id: daas-list-delivery-groups
title: "List Citrix DaaS Delivery Groups and Machine Counts"
language: powershell
tags: ["Citrix DaaS", "Monitoring"]
prerequisites: ["Bearer token + Citrix-CustomerId header (see: Authenticate to Citrix DaaS)"]
---

Pull all Delivery Groups from Citrix DaaS with desktop counts and current load state — quick tenant-wide overview.

```powershell
$siteId = "<SiteId>"

Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/DeliveryGroups?siteId=$siteId" -Headers $headers |
    Select-Object -ExpandProperty Items |
    Select-Object Name, TotalDesktops, DesktopsAvailable, DeliveryType
```
