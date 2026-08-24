---
id: nvidia-vgpu-license-check
title: "Check NVIDIA vGPU License Status on a VDA Host"
language: powershell
tags: ["NVIDIA", "GPU", "Licensing"]
prerequisites: ["NVIDIA vGPU driver installed on the host", "Run locally or via remote session on the VDA/hypervisor host"]
---

Read the vGPU licensing status directly from nvidia-smi — common check when GPU-accelerated sessions fall back to unlicensed mode.

```powershell
$result = Invoke-Command -ComputerName "VDA-GPU-01" -ScriptBlock {
    & 'C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe' -q | Select-String "License Status", "vGPU Software Licensed Product"
}

$result
```
