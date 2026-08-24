---
id: intune-app-assignment-check
title: "Check a User's Intune App Assignments"
language: powershell
tags: ["Intune", "Apps", "Troubleshooting"]
prerequisites: []
---

List all apps assigned to a user, whether directly or via group membership — useful for 'app won't install' tickets.

```powershell
$upn = "user@contoso.com"
$user = Get-MgUser -UserId $upn
$groups = Get-MgUserMemberOf -UserId $user.Id | Select-Object -ExpandProperty Id

Get-MgDeviceAppManagementMobileApp -All | ForEach-Object {
    $assignments = Get-MgDeviceAppManagementMobileAppAssignment -MobileAppId $_.Id
    if ($assignments.Target.GroupId -in $groups) {
        [PSCustomObject]@{ App = $_.DisplayName; Intent = $assignments.Intent }
    }
}
```
