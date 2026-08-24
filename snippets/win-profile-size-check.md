---
id: win-profile-size-check
title: "Check Profile Size Across Multiple Users (FSLogix/Roaming)"
language: powershell
tags: ["Windows", "Profile Management", "FSLogix", "Performance"]
prerequisites: []
---

Measure the size of profile containers/folders for multiple users — useful when troubleshooting slow logon performance.

```powershell
$profilePath = "\\fileserver\FSLProfiles$"

Get-ChildItem $profilePath -Directory | ForEach-Object {
    $size = (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum / 1GB
    [PSCustomObject]@{ User = $_.Name; SizeGB = [math]::Round($size, 2) }
} | Sort-Object SizeGB -Descending
```
