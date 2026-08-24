---
id: monitoring-failed-scheduled-tasks
title: "Find Failed Scheduled Tasks Across Multiple Servers"
language: powershell
tags: ["Monitoring", "Windows", "Troubleshooting"]
prerequisites: ["PowerShell remoting enabled on target servers"]
---

Scan scheduled tasks on multiple servers for a non-zero last run result — surfaces silently failing maintenance/backup jobs.

```powershell
$servers = @("CTX-DDC-01", "FS-01")

Invoke-Command -ComputerName $servers -ScriptBlock {
    Get-ScheduledTask | Get-ScheduledTaskInfo |
        Where-Object { $_.LastTaskResult -ne 0 -and $_.LastRunTime } |
        Select-Object TaskName, LastRunTime, LastTaskResult
} | Select-Object PSComputerName, TaskName, LastRunTime, LastTaskResult
```
