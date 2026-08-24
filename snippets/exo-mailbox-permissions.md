---
id: exo-mailbox-permissions
title: "Exchange Online – Check Mailbox Permissions"
language: powershell
tags: ["Exchange Online", "Permissions"]
prerequisites: []
---

List all Full Access and Send As permissions on a mailbox, excluding inherited SELF entries.

```powershell
$mailbox = "user@contoso.com"

Get-MailboxPermission -Identity $mailbox |
    Where-Object { $_.User -notlike "NT AUTHORITY\SELF" }

Get-RecipientPermission -Identity $mailbox
```
