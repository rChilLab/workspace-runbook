---
id: entra-users-without-mfa
title: "List Users Without MFA Registered"
language: powershell
tags: ["Entra ID", "MFA", "Security"]
prerequisites: ["Graph scope: Reports.Read.All", "Azure AD Premium P1/P2 for full registration detail"]
---

Pull authentication method registration details for all users and filter down to accounts with no MFA registered.

```powershell
Get-MgReportAuthenticationMethodUserRegistrationDetail -All |
    Where-Object { -not $_.IsMfaRegistered } |
    Select-Object UserPrincipalName, IsMfaRegistered, MethodsRegistered, UserType
```
