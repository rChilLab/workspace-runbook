---
id: deploy-intune-autopilot-assign
title: "Assign an Autopilot Profile to a Device Group"
language: powershell
tags: ["Deployment", "Intune", "Autopilot"]
prerequisites: ["Graph connection with DeviceManagementServiceConfig.ReadWrite.All", "Devices already imported as Autopilot devices", "Target group exists in Entra ID"]
---

Assign a deployment (Autopilot) profile to an Entra ID group — the last step before shipping new devices to the customer.

```powershell
$profileId = "<AutopilotProfileId>"
$groupId = "<EntraGroupId>"

$assignment = @{
    target = @{
        "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
        groupId = $groupId
    }
}

New-MgDeviceManagementWindowsAutopilotDeploymentProfileAssignment `
    -WindowsAutopilotDeploymentProfileId $profileId -BodyParameter $assignment
```
