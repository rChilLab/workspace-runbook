---
id: citrix-upm-exclusions-check
title: "Check Citrix UPM Include/Exclude List on a Session Host"
language: powershell
tags: ["Citrix", "Profile Management", "Troubleshooting"]
prerequisites: ["Local admin rights on the session host (reads HKLM policy keys)"]
---

Read the effective Profile Management Include/Exclude folder lists applied via GPO — first check when a folder unexpectedly ends up in (or out of) the profile.

```powershell
$policyPath = "HKLM:\SOFTWARE\Policies\Citrix\UserProfileManager"

[PSCustomObject]@{
    Enabled          = (Get-ItemProperty -Path $policyPath -Name ServiceActive -ErrorAction SilentlyContinue).ServiceActive
    IncludeFolders   = (Get-ItemProperty -Path "$policyPath\Sync List" -ErrorAction SilentlyContinue)
    ExcludeFolders   = (Get-ItemProperty -Path "$policyPath\ExclusionListSync" -ErrorAction SilentlyContinue)
}
```
