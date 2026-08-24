---
id: intune-noncompliant-devices
title: "List Non-Compliant Intune Devices"
language: powershell
tags: ["Intune", "Compliance", "Graph"]
prerequisites: []
---

List all devices with a 'noncompliant' status, including the policy responsible.

```powershell
$devices = Get-MgDeviceManagementManagedDevice -All |
    Where-Object { $_.ComplianceState -eq 'noncompliant' }

$devices | Select-Object DeviceName, UserPrincipalName, ComplianceState, LastSyncDateTime |
    Sort-Object LastSyncDateTime
```
