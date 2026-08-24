---
id: daas-cloud-api-auth
title: "Authenticate to Citrix DaaS (Cloud API Bearer Token)"
language: powershell
tags: ["Citrix DaaS", "Auth", "Cloud"]
prerequisites: ["Citrix Cloud API Client (Client ID + Secret) created under Identity and Access Management", "Citrix Cloud Customer ID"]
---

Get a bearer token for the Citrix DaaS REST API using a Cloud API Client — the base call every other DaaS API request builds on.

```powershell
$customerId = "<CustomerId>"
$clientId = "<ApiClientId>"
$clientSecret = "<ApiClientSecret>"

$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
}

$token = Invoke-RestMethod -Uri "https://api.cloud.com/cctrustoauth2/root/tokens/clients" -Method Post -Body $body

$headers = @{
    Authorization       = "CwsAuth Bearer=$($token.access_token)"
    "Citrix-CustomerId" = $customerId
    Accept              = "application/json"
}

$headers
```
