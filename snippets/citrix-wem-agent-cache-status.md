---
id: citrix-wem-agent-cache-status
title: "Check WEM Agent Service and Last Cache Refresh"
language: powershell
tags: ["Citrix", "WEM", "Monitoring"]
prerequisites: ["WEM Agent installed on target hosts", "PowerShell remoting enabled"]
---

Check the Norskale/WEM Agent Host service status and last successful cache refresh timestamp across multiple session hosts.

```powershell
$hosts = @("CTX-VDA-01", "CTX-VDA-02")

Invoke-Command -ComputerName $hosts -ScriptBlock {
    $service = Get-Service -Name "Norskale Agent Host Service" -ErrorAction SilentlyContinue
    $lastRefresh = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Norskale\Agent Host" -Name LastRefresh -ErrorAction SilentlyContinue).LastRefresh
    [PSCustomObject]@{ Service = $service.Status; LastRefresh = $lastRefresh }
} | Select-Object PSComputerName, Service, LastRefresh
```
