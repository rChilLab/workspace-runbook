---
id: xenserver-host-status
title: "Check XenServer/Citrix Hypervisor Host Resource Pool Status"
language: powershell
tags: ["XenServer", "Hypervisor", "Monitoring"]
prerequisites: ["Citrix Hypervisor PowerShell SDK installed", "Network access to the pool master on TCP 443"]
---

List all hosts in a resource pool with CPU, memory, and connection state — a quick health check before maintenance.

```powershell
Import-Module XenServerPSModule

$session = Connect-XenServer -Server "xenserver01.contoso.local" -UserName "root" -Password (Read-Host -AsSecureString)

Get-XenHost | Get-XenObject | Select-Object name_label, @{n='CPUs';e={$_.cpu_info.cpu_count}}, @{n='MemoryGB';e={[math]::Round($_.memory_total/1GB,1)}}, enabled
```
