---
id: monitoring-server-uptime-multi
title: "Check Last Reboot Time Across Multiple Servers"
language: powershell
tags: ["Monitoring", "Windows", "Health Check"]
prerequisites: ["PowerShell remoting or WMI/CIM access to target servers"]
---

Report last boot time and current uptime for a list of servers — quick check before assuming a patch cycle rebooted everything.

```powershell
$servers = @("CTX-DDC-01", "CTX-VDA-01", "FS-01")

Get-CimInstance -ComputerName $servers -ClassName Win32_OperatingSystem |
    Select-Object PSComputerName,
        @{n='LastBoot';e={$_.LastBootUpTime}},
        @{n='UptimeDays';e={[math]::Round(((Get-Date) - $_.LastBootUpTime).TotalDays,1)}} |
    Sort-Object UptimeDays -Descending
```
