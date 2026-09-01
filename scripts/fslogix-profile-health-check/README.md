# FSLogix Profile Health Check

Scannt einen oder mehrere FSLogix Profile Shares auf verwaiste VHD(X)-Locks,
Größenanomalien und grundlegende Integritätsprobleme. Läuft ad-hoc oder
geplant (z. B. als Scheduled Task) gegen einen oder mehrere File Server.

## Voraussetzungen

- PowerShell 7+
- Leserechte auf dem/den Profile Share(s)
- Optional: Hyper-V-Modul (`Get-VHD`) für den vollständigen Integritäts-Check —
  ohne das Modul läuft ein einfacherer Signatur-Check als Fallback

## Parameter

| Parameter            | Typ      | Pflicht | Beschreibung                                                        |
| --------------------- | -------- | ------- | ---------------------------------------------------------------------- |
| `-ProfileSharePath`   | string[] | ja      | Ein oder mehrere UNC-/lokale Pfade zu FSLogix Profile Shares            |
| `-SizeThresholdGB`    | int      | nein    | Schwellwert in GB, ab dem ein Container als "oversized" markiert wird (Default: 30) |
| `-ExportPath`         | string   | nein    | Zielverzeichnis für den CSV-Report (Default: aktuelles Verzeichnis)     |
| `-SkipIntegrityCheck` | switch   | nein    | Überspringt den Integritäts-Check (deutlich schneller bei vielen Containern) |
| `-OnlyScan`           | switch   | nein    | Nur scannen und in der Konsole ausgeben, kein CSV-Export                |
| `-Verbose`            | switch   | nein    | Ausführliches Logging via `Write-Verbose`                              |

## Beispiele

Einzelnen Share prüfen, Report ins aktuelle Verzeichnis:

```powershell
.\script.ps1 -ProfileSharePath '\\fs01\profiles$'
```

Mehrere Shares, eigener Schwellwert, Report nach `C:\Reports`:

```powershell
.\script.ps1 -ProfileSharePath '\\fs01\profiles$', '\\fs02\profiles$' `
    -SizeThresholdGB 40 `
    -ExportPath 'C:\Reports'
```

Schneller Scan ohne Integritäts-Check und ohne Export, nur Konsolen-Output:

```powershell
.\script.ps1 -ProfileSharePath '\\fs01\profiles$' -SkipIntegrityCheck -OnlyScan -Verbose
```

## Output

CSV mit einer Zeile pro gefundenem Container:

| Spalte          | Beschreibung                                             |
| ----------------- | ----------------------------------------------------------- |
| Owner              | Aus dem Ordnernamen abgeleiteter Benutzername                |
| SID                | Aus dem Ordnernamen abgeleitete SID (falls erkennbar)         |
| Path               | Vollständiger Pfad zur VHD/VHDX-Datei                         |
| SizeGB             | Größe des Containers in GB                                    |
| LastWriteTime      | Letzte Schreib-Zeit                                            |
| IsLocked           | `true`, wenn die Datei aktuell exklusiv gesperrt ist           |
| IsOversized        | `true`, wenn `SizeGB` über `-SizeThresholdGB` liegt            |
| IsIntegrityOk      | `true`/`false`/`$null` (bei `-SkipIntegrityCheck` immer `$null`) |
| Issue              | Zusammenfassung aller erkannten Probleme, `;`-getrennt          |

## Hinweise

- Ein `IsLocked = true` bedeutet nicht zwingend ein Problem — der Nutzer kann
  aktuell eingeloggt sein. Zur Diagnose "verwaister" Locks am besten mit einer
  aktiven Sessions-Liste (z. B. aus Citrix oder RDS) gegenprüfen.
- Der Signatur-Fallback (ohne Hyper-V-Modul) erkennt nur grob beschädigte
  Header, keine tieferliegende Dateisystem-Korruption innerhalb des Containers.
- Bei sehr großen Shares (>10.000 Container) empfiehlt sich `-SkipIntegrityCheck`
  für den täglichen Lauf und ein vollständiger Check nur wöchentlich.
