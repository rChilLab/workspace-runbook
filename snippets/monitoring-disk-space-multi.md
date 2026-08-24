---
id: monitoring-disk-space-multi
title: "Check Free Disk Space Across Multiple Servers"
language: powershell
tags: ["Monitoring", "Windows", "Health Check"]
prerequisites: ["PowerShell remoting or WMI/CIM access to target servers"]
---

Report free disk space per volume across a server list, flagging anything under a set threshold.

```powershell
$servers = @("CTX-DDC-01", "CTX-VDA-01", "FS-01")
$thresholdPercent = 15

Get-CimInstance -ComputerName $servers -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object PSComputerName, DeviceID,
        @{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}},
        @{n='FreePercent';e={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}} |
    Where-Object { $_.FreePercent -lt $thresholdPercent }
```
