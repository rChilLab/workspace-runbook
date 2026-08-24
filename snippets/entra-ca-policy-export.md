---
id: entra-ca-policy-export
title: "Export Conditional Access Policies"
language: powershell
tags: ["Entra ID", "Conditional Access", "Documentation"]
prerequisites: []
---

Export all CA policies including status as JSON — useful for documentation or comparing tenants.

```powershell
$policies = Get-MgIdentityConditionalAccessPolicy -All

$policies | Select-Object DisplayName, State, CreatedDateTime |
    ConvertTo-Json -Depth 5 | Out-File ".\CA-Policies-Export.json"
```
