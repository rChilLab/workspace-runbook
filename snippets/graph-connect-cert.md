---
id: graph-connect-cert
title: "Connect-MgGraph with App-Only Auth (Certificate)"
language: powershell
tags: ["Graph", "Auth", "Automation"]
prerequisites: []
---

Connect to Microsoft Graph via app registration and certificate auth — ideal for automation and runbooks without an interactive login.

```powershell
Connect-MgGraph -ClientId "<AppId>" `
    -TenantId "<TenantId>" `
    -CertificateThumbprint "<Thumbprint>"

Get-MgContext | Select-Object Account, TenantId, Scopes
```
