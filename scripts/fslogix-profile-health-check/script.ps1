#Requires -Version 7.0
<#
    FSLogix Profile Health Check

    Scannt einen oder mehrere FSLogix Profile Shares auf:
      - verwaiste Locks (VHD(X) durch einen abgestürzten Prozess offen gehalten)
      - Größenanomalien (Container über einem definierten Schwellwert)
      - grundlegende Integritätsprobleme (Datei nicht als valides VHD(X) lesbar)

    Siehe README.md für Parameter, Beispiele und Output-Format.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string[]]$ProfileSharePath,

    [ValidateRange(1, 500)]
    [int]$SizeThresholdGB = 30,

    [string]$ExportPath = (Get-Location).Path,

    [switch]$SkipIntegrityCheck,

    [switch]$OnlyScan
)

function Get-FSLogixContainerInventory {
    <#
        Zweck: Findet alle VHD/VHDX-Container unterhalb eines Profile-Share-Pfads
               und leitet Benutzername + SID aus dem Ordnernamen ab.
        Parameter:
          -SharePath : UNC- oder lokaler Pfad zum FSLogix Profile Share
        Beispiel:
          Get-FSLogixContainerInventory -SharePath '\\fileserver\profiles$'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SharePath
    )

    if (-not (Test-Path -LiteralPath $SharePath)) {
        Write-Warning "Pfad nicht erreichbar, wird übersprungen: $SharePath"
        return @()
    }

    Write-Verbose "Durchsuche $SharePath nach VHD/VHDX-Containern ..."
    $containers = Get-ChildItem -LiteralPath $SharePath -Recurse -Include '*.vhd', '*.vhdx' -File -ErrorAction SilentlyContinue

    foreach ($file in $containers) {
        $folderName = Split-Path -Path (Split-Path -Path $file.FullName -Parent) -Leaf
        $sidMatch = [regex]::Match($folderName, 'S-\d-\d+(-\d+){1,14}')
        $sid = if ($sidMatch.Success) { $sidMatch.Value } else { $null }
        $owner = if ($sid) { $folderName.Replace("_$sid", '').Replace("${sid}_", '') } else { $folderName }

        [PSCustomObject]@{
            Path          = $file.FullName
            Owner         = $owner
            SID           = $sid
            SizeGB        = [math]::Round($file.Length / 1GB, 2)
            LastWriteTime = $file.LastWriteTime
        }
    }
}

function Test-FSLogixContainerLock {
    <#
        Zweck: Prüft, ob ein Container-File aktuell exklusiv gesperrt ist
               (z. B. durch eine hängende Session oder einen abgestürzten Prozess).
        Parameter:
          -Path : Vollständiger Pfad zur VHD/VHDX-Datei
        Beispiel:
          Test-FSLogixContainerLock -Path 'C:\Profiles\jdoe\Profile_S-1-5-21.vhdx'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        $stream = [System.IO.File]::Open($Path, 'Open', 'Read', 'None')
        $stream.Close()
        return $false
    }
    catch [System.IO.IOException] {
        return $true
    }
    catch {
        Write-Warning "Lock-Test fehlgeschlagen für '$Path': $($_.Exception.Message)"
        return $null
    }
}

function Test-FSLogixContainerIntegrity {
    <#
        Zweck: Prüft grundlegend, ob eine VHD/VHDX-Datei ein valider Container ist.
               Nutzt Get-VHD (Hyper-V-Modul), falls verfügbar, sonst einen einfachen
               Header-Check auf die "conectix"/"vhdxfile"-Signatur.
        Parameter:
          -Path : Vollständiger Pfad zur VHD/VHDX-Datei
        Beispiel:
          Test-FSLogixContainerIntegrity -Path 'C:\Profiles\jdoe\Profile_S-1-5-21.vhdx'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Get-Command Get-VHD -ErrorAction SilentlyContinue) {
        try {
            Get-VHD -Path $Path -ErrorAction Stop | Out-Null
            return $true
        }
        catch {
            Write-Verbose "Get-VHD meldet Problem bei '$Path': $($_.Exception.Message)"
            return $false
        }
    }

    # Fallback ohne Hyper-V-Modul: rudimentärer Signatur-Check
    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)[0..7]
        $header = [System.Text.Encoding]::ASCII.GetString($bytes)
        return ($header -eq 'conectix' -or $header -eq 'vhdxfile')
    }
    catch {
        Write-Warning "Integritäts-Check nicht möglich für '$Path': $($_.Exception.Message)"
        return $null
    }
}

function Invoke-FSLogixHealthCheck {
    <#
        Zweck: Orchestriert Inventory, Lock-Check und Integritäts-Check über
               eine Liste von Profile Shares und liefert eine konsolidierte
               Ergebnisliste zurück.
        Parameter:
          -SharePath          : Ein oder mehrere Profile-Share-Pfade
          -SizeThresholdGB    : Schwellwert für "oversized" Container
          -SkipIntegrityCheck : Integritäts-Check überspringen (schneller)
        Beispiel:
          Invoke-FSLogixHealthCheck -SharePath '\\fs01\profiles$' -SizeThresholdGB 30
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$SharePath,

        [int]$SizeThresholdGB = 30,

        [switch]$SkipIntegrityCheck
    )

    $results = foreach ($share in $SharePath) {
        $inventory = Get-FSLogixContainerInventory -SharePath $share
        Write-Verbose "$($inventory.Count) Container gefunden unter $share"

        foreach ($container in $inventory) {
            $isLocked = Test-FSLogixContainerLock -Path $container.Path
            $isIntegrityOk = if ($SkipIntegrityCheck) { $null } else { Test-FSLogixContainerIntegrity -Path $container.Path }
            $isOversized = $container.SizeGB -gt $SizeThresholdGB

            $issue = @()
            if ($isLocked) { $issue += 'Locked' }
            if ($isOversized) { $issue += 'Oversized' }
            if ($isIntegrityOk -eq $false) { $issue += 'IntegrityFailed' }

            [PSCustomObject]@{
                Owner         = $container.Owner
                SID           = $container.SID
                Path          = $container.Path
                SizeGB        = $container.SizeGB
                LastWriteTime = $container.LastWriteTime
                IsLocked      = $isLocked
                IsOversized   = $isOversized
                IsIntegrityOk = $isIntegrityOk
                Issue         = ($issue -join ';')
            }
        }
    }

    return $results
}

function Export-FSLogixHealthReport {
    <#
        Zweck: Exportiert die Ergebnisliste als CSV.
        Parameter:
          -Results    : Ergebnis-Objekte aus Invoke-FSLogixHealthCheck
          -ExportPath : Zielverzeichnis für die CSV-Datei
        Beispiel:
          Export-FSLogixHealthReport -Results $results -ExportPath 'C:\Reports'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$Results,

        [Parameter(Mandatory)]
        [string]$ExportPath
    )

    try {
        if (-not (Test-Path -LiteralPath $ExportPath)) {
            New-Item -Path $ExportPath -ItemType Directory -Force | Out-Null
        }
        $file = Join-Path -Path $ExportPath -ChildPath "fslogix-health-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
        $Results | Export-Csv -Path $file -NoTypeInformation -Encoding UTF8
        Write-Verbose "Report geschrieben: $file"
        return $file
    }
    catch {
        Write-Error "Export fehlgeschlagen: $_"
    }
}

# --- Main ---

try {
    $healthResults = Invoke-FSLogixHealthCheck -SharePath $ProfileSharePath -SizeThresholdGB $SizeThresholdGB -SkipIntegrityCheck:$SkipIntegrityCheck

    $flagged = $healthResults | Where-Object { $_.Issue }
    Write-Host "$($healthResults.Count) Container geprüft, $($flagged.Count) mit Auffälligkeiten."

    if (-not $OnlyScan) {
        $reportPath = Export-FSLogixHealthReport -Results $healthResults -ExportPath $ExportPath
        Write-Host "Report: $reportPath"
    }

    $healthResults
}
catch {
    Write-Error "FSLogix Health Check fehlgeschlagen: $_"
}
