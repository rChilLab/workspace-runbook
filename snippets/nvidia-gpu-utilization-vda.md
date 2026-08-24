---
id: nvidia-gpu-utilization-vda
title: "Check NVIDIA GPU Utilization Across VDA Hosts"
language: powershell
tags: ["NVIDIA", "GPU", "Performance", "Citrix"]
prerequisites: ["NVIDIA driver with nvidia-smi installed on each host", "PowerShell remoting enabled"]
---

Pull current GPU utilization and memory usage from multiple VDA hosts in one call — helpful when diagnosing sluggish graphics performance.

```powershell
$hosts = @("VDA-GPU-01", "VDA-GPU-02")

Invoke-Command -ComputerName $hosts -ScriptBlock {
    & 'C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe' --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader
} | Select-Object PSComputerName, @{n='Output';e={$_.ToString()}}
```
