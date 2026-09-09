---
id: fslogix-set-ntfs-permissions
title: "Set FSLogix NTFS Permissions"
version: "1.0.0"
tags: ["FSLogix", "File Server", "Permissions"]
---

Setzt die von Microsoft empfohlenen NTFS-Berechtigungen für ein FSLogix-Profilverzeichnis: Users-Gruppe mit `Modify` (nur auf den Ordner selbst), `CREATOR OWNER` mit `Modify` (nur auf Unterordner/Dateien, für neu angelegte Container), sowie `Administrators` und `SYSTEM` mit `FullControl`.

## Voraussetzungen

- PowerShell 5.1+
- Lokaler Admin auf dem File Server (Set-Acl erfordert entsprechende Rechte)
- Pfad muss **lokal** angegeben werden (nicht als UNC-Pfad) — direkt auf dem File Server ausführen

## Parameter

| Parameter             | Typ    | Pflicht | Beschreibung                                                              |
| ----------------------- | ------ | ------- | ---------------------------------------------------------------------------- |
| `-Path`                 | string | ja      | Lokaler Pfad zum Freigabeverzeichnis, z. B. `D:\FSLogixShare\Profiles`         |
| `-UsersGroup`           | string | ja      | Gruppe, die FSLogix-Container anlegen darf, z. B. `CONTOSO\FSLogix-Users`      |
| `-AdminsGroup`          | string | nein    | Administratoren-Gruppe (Default: `BUILTIN\Administrators`)                    |
| `-DisableInheritance`   | switch | nein    | Entfernt vererbte ACEs, setzt nur die definierten Regeln                       |
| `-WhatIf`               | switch | nein    | Zeigt, was geändert würde, ohne die ACL tatsächlich zu setzen (`SupportsShouldProcess`) |
| `-Verbose`              | switch | nein    | Ausführliches Logging via `Write-Verbose`                                     |

## Beispiele

Erst als Trockenlauf prüfen, was sich ändern würde:

```powershell
Set-FSLogixNtfsPermission -Path 'D:\FSLogixShare\Profiles' -UsersGroup 'CONTOSO\FSLogix-Users' -WhatIf
```

Vererbung deaktivieren und Berechtigungen sauber neu setzen, mit Logging:

```powershell
Set-FSLogixNtfsPermission -Path 'D:\FSLogixShare\Profiles' -UsersGroup 'CONTOSO\FSLogix-Users' -DisableInheritance -Verbose
```

Mit abweichender Admin-Gruppe:

```powershell
Set-FSLogixNtfsPermission -Path 'D:\FSLogixShare\Profiles' -UsersGroup 'CONTOSO\FSLogix-Users' -AdminsGroup 'CONTOSO\IT-Admins'
```

## Hinweise

- `-DisableInheritance` entfernt **alle** bestehenden ACEs, bevor die neuen Regeln gesetzt werden — auf einem bereits produktiven Share vorher unbedingt mit `-WhatIf` prüfen.
- Die Funktion unterstützt `-WhatIf`/`-Confirm` über `SupportsShouldProcess` — bei Unsicherheit immer zuerst als Trockenlauf ausführen.
- Gilt nur für das Root-Verzeichnis des Shares selbst; einzelne bereits angelegte Profil-Ordner darunter erben die Regeln nur bei entsprechend gesetzten Inheritance-Flags neu angelegter Container (Windows setzt das beim ersten Login automatisch über `CREATOR OWNER`).
