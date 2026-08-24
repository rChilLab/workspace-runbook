---
id: win-service-status-multi
title: "Check Service Status Across Multiple Servers"
language: powershell
tags: ["Windows", "Services", "Citrix", "Monitoring"]
prerequisites: []
---

Query the status of a specific Windows service (e.g. Citrix Broker Service) in parallel across multiple servers.

```powershell
$servers = @("CTX-DDC-01", "CTX-DDC-02", "CTX-STOREFRONT-01")
$serviceName = "CitrixBrokerService"

Invoke-Command -ComputerName $servers -ScriptBlock {
    Get-Service -Name $using:serviceName | Select-Object MachineName, Status, StartType
} | Select-Object PSComputerName, Status, StartType
```
