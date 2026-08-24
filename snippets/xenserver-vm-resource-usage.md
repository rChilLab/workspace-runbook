---
id: xenserver-vm-resource-usage
title: "List VM Resource Usage on a XenServer Host"
language: powershell
tags: ["XenServer", "Performance"]
prerequisites: ["Citrix Hypervisor PowerShell SDK installed", "Active session via Connect-XenServer"]
---

Overview of all running VMs on a host with allocated vCPUs and memory — useful before consolidating or resizing workloads.

```powershell
$vms = Get-XenVM | Get-XenObject | Where-Object { $_.power_state -eq "Running" }

$vms | Select-Object name_label, @{n='vCPUs';e={$_.VCPUs_max}}, @{n='MemoryGB';e={[math]::Round($_.memory_dynamic_max/1GB,1)}} |
    Sort-Object MemoryGB -Descending
```
