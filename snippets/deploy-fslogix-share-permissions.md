---
id: deploy-fslogix-share-permissions
title: "Prepare an FSLogix Profile Share (NTFS + Share Permissions)"
language: powershell
tags: ["Deployment", "FSLogix", "File Server"]
prerequisites: ["Local admin rights on the file server", "AD group for authorized users already exists", "Firewall: inbound TCP 445 (SMB) allowed on the file server (client subnet)"]
---

Create a share for FSLogix profile containers with correct NTFS and share permissions for a security group.

```powershell
$path = "D:\FSLProfiles"
$shareName = "FSLProfiles$"
$group = "CONTOSO\FSLogix-Users"

New-Item -Path $path -ItemType Directory -Force
New-SmbShare -Name $shareName -Path $path -FullAccess "Everyone"

icacls $path /grant "${group}:(OI)(CI)M"
icacls $path /remove "Everyone"
icacls $path /grant "SYSTEM:(OI)(CI)F" "CREATOR OWNER:(OI)(CI)(IO)F"
```
