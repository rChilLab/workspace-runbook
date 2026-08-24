---
id: entra-pim-active-assignments
title: "List Active PIM Role Assignments"
language: powershell
tags: ["Entra ID", "PIM", "Security"]
prerequisites: ["Graph scope: RoleManagement.Read.Directory"]
---

Show all currently active (not just eligible) privileged role assignments across the tenant — useful for access reviews.

```powershell
$assignments = Get-MgRoleManagementDirectoryRoleAssignmentScheduleInstance -All

$assignments | ForEach-Object {
    $principal = Get-MgDirectoryObject -DirectoryObjectId $_.PrincipalId
    $role = Get-MgRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $_.RoleDefinitionId
    [PSCustomObject]@{
        Principal = $principal.AdditionalProperties.displayName
        Role      = $role.DisplayName
        EndTime   = $_.ScheduleInfo.Expiration.EndDateTime
    }
}
```
