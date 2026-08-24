---
id: citrix-wem-force-cache-refresh
title: "Force a WEM Agent Cache Refresh Remotely"
language: powershell
tags: ["Citrix", "WEM", "Troubleshooting"]
prerequisites: ["WEM Agent installed on target host", "AgentCacheUtility.exe present in the WEM Agent install directory", "PowerShell remoting enabled"]
---

Trigger an immediate WEM Agent cache refresh on a host instead of waiting for the scheduled interval — useful right after publishing a config change.

```powershell
$targetHost = "CTX-VDA-01"

Invoke-Command -ComputerName $targetHost -ScriptBlock {
    & "C:\Program Files (x86)\Citrix\Workspace Environment Management Agent\AgentCacheUtility.exe" -refreshcache
}
```
