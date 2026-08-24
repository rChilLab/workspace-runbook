---
id: deploy-fslogix-silent-install
title: "FSLogix Silent Install + Base Configuration"
language: powershell
tags: ["Deployment", "FSLogix", "Profile Management"]
prerequisites: ["Local admin rights", "MSI from the official FSLogix download package", "Profile share already created (SMB, permissions set)", "Firewall: outbound TCP 445 (SMB) to the file server allowed"]
---

Install the FSLogix Apps agent unattended and set the base profile container configuration via registry.

```powershell
Start-Process msiexec.exe -ArgumentList "/i FSLogixAppsSetup.exe /quiet /norestart" -Wait

$regPath = "HKLM:\SOFTWARE\FSLogix\Profiles"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path $regPath -Name "VHDLocations" -Value "\\fileserver\FSLProfiles$" -Type MultiString
Set-ItemProperty -Path $regPath -Name "SizeInMBs" -Value 30000 -Type DWord
Set-ItemProperty -Path $regPath -Name "IsDynamic" -Value 1 -Type DWord
```
