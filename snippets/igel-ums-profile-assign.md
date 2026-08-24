---
id: igel-ums-profile-assign
title: "Assign an Igel UMS Profile to a Device Group"
language: powershell
tags: ["Igel UMS", "Deployment"]
prerequisites: ["Igel UMS Webservice API enabled", "API user with write permissions", "Profile and target directory already exist in UMS"]
---

Assign a configuration profile to all devices in a UMS directory — standard step when rolling out a new thin-client config.

```powershell
$umsServer = "https://ums01.contoso.local:8443"
$profileId = "<ProfileId>"
$directoryId = "<DirectoryId>"
$headers = @{ Authorization = "Basic <Base64Credentials>" }

$body = @{ profileId = $profileId; directoryId = $directoryId } | ConvertTo-Json

Invoke-RestMethod -Uri "$umsServer/umsapi/v1/profiles/assign" -Method Post -Headers $headers -Body $body -ContentType "application/json"
```
