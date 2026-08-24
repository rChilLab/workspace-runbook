---
id: igel-ums-device-list
title: "List Igel UMS Devices via REST API"
language: powershell
tags: ["Igel UMS", "Igel OS", "Inventory"]
prerequisites: ["Igel UMS Webservice API enabled", "API user with read permissions", "Firewall: outbound TCP 8443 to the UMS server"]
---

Retrieve all managed Igel OS endpoints from the UMS, including firmware version and online status.

```powershell
$umsServer = "https://ums01.contoso.local:8443"
$cred = Get-Credential

$auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($cred.UserName):$($cred.GetNetworkCredential().Password)"))
$headers = @{ Authorization = "Basic $auth" }

Invoke-RestMethod -Uri "$umsServer/umsapi/v1/devices" -Headers $headers |
    Select-Object name, firmwareVersion, onlineState
```
