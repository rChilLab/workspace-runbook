---
id: deploy-cloud-connector-install
title: "Citrix Cloud Connector Silent Install"
language: powershell
tags: ["Deployment", "Citrix", "Cloud Connector"]
prerequisites: ["Local admin rights", "Outbound HTTPS to *.citrixworkspacesapi.net", "Firewall: outbound TCP 443 to *.cloud.com, *.citrixnetworkapi.net, *.blob.core.windows.net", "Citrix Cloud customer ID + API keys available"]
---

Install the Cloud Connector unattended and assign it to a Resource Location — a standard step when onboarding new VDA hosts.

```powershell
$installer = "CitrixCloudConnectorInstaller.exe"
$customerId = "<CustomerId>"
$clientId = "<ApiClientId>"
$clientSecret = "<ApiClientSecret>"
$resourceLocation = "On-Prem-DC1"

Start-Process $installer -ArgumentList `
    "/q /customerid $customerId /clientid $clientId /clientsecret $clientSecret /resourcelocation `"$resourceLocation`"" `
    -Wait -PassThru
```
