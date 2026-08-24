---
id: win-gpresult-rsop-remote
title: "Get GPO Results from a Remote Machine"
language: powershell
tags: ["Windows", "GPO", "Troubleshooting"]
prerequisites: []
---

Generate an RSoP report (applied GPOs) for a remote machine — a classic check when 'the policy isn't applying'.

```powershell
$computer = "CTX-VDA-042"

Invoke-Command -ComputerName $computer -ScriptBlock {
    gpresult /h C:\Temp\RSoP.html /f
}

Copy-Item "\\$computer\C$\Temp\RSoP.html" -Destination ".\RSoP-$computer.html"
```
