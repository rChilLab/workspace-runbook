---
id: citrix-session-details-user
title: "List a User's Citrix Sessions"
language: powershell
tags: ["Citrix", "Sessions", "Troubleshooting"]
prerequisites: []
---

Active and disconnected sessions for a user, including client IP, connect time, and server — useful for 'user is stuck' tickets.

```powershell
Get-BrokerSession -UserName "CONTOSO\jdoe" |
    Select-Object MachineName, SessionState, ClientAddress, ConnectedViaHostName, StartTime |
    Sort-Object StartTime -Descending
```
