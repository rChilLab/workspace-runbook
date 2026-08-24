---
id: daas-machine-catalog-provisioning-status
title: "Check Citrix DaaS Machine Catalog Provisioning Status"
language: powershell
tags: ["Citrix DaaS", "Troubleshooting"]
prerequisites: ["Bearer token + Citrix-CustomerId header (see: Authenticate to Citrix DaaS)"]
---

Check provisioning scheme status of a machine catalog — useful when new VMs get stuck mid-rollout.

```powershell
$siteId = "<SiteId>"
$catalogId = "<MachineCatalogId>"

Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$catalogId`?siteId=$siteId" -Headers $headers |
    Select-Object Name, ProvisioningType, ProvisioningSchemeStatus, TotalCount
```
