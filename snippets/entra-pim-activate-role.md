---
id: entra-pim-activate-role
title: "Activate an Eligible PIM Role Assignment"
language: powershell
tags: ["Entra ID", "PIM", "Automation"]
prerequisites: ["Graph scope: RoleManagement.ReadWrite.Directory", "Caller must already be eligible for the target role"]
---

Activate a time-bound PIM role assignment via Graph — useful for scripted break-glass or automation scenarios instead of the Azure Portal UI.

```powershell
$params = @{
    Action           = "selfActivate"
    PrincipalId      = "<UserObjectId>"
    RoleDefinitionId = "<RoleDefinitionId>"
    DirectoryScopeId = "/"
    Justification    = "Scheduled maintenance"
    ScheduleInfo     = @{
        StartDateTime = (Get-Date).ToUniversalTime()
        Expiration    = @{ Type = "AfterDuration"; Duration = "PT4H" }
    }
}

New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params
```
