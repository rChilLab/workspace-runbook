---
id: citrix-vda-registration-state
title: "Check Citrix VDA Registration State"
language: powershell
tags: ["Citrix", "VDA", "Troubleshooting"]
prerequisites: []
---

Query the registration state of all VDAs in a Delivery Group — the first step when a session won't launch.

```powershell
Add-PSSnapin Citrix.Broker.Admin.V2

Get-BrokerMachine -DesktopGroupName "DG-Prod-01" |
    Select-Object MachineName, RegistrationState, PowerState, InMaintenanceMode |
    Sort-Object RegistrationState
```
