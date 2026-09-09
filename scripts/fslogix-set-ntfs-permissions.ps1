#requires -Version 5.1

function Set-FSLogixNtfsPermission {
    <#
    .SYNOPSIS
        Setzt die von Microsoft empfohlenen NTFS-Berechtigungen für ein FSLogix-Profilverzeichnis.
    .PARAMETER Path
        Lokaler Pfad zum Freigabeverzeichnis (nicht UNC), z. B. D:\FSLogixShare\Profiles.
    .PARAMETER UsersGroup
        Security Group / Users, die FSLogix-Container anlegen dürfen (Domain\Group).
    .PARAMETER AdminsGroup
        Administratoren-Gruppe (Standard: BUILTIN\Administrators).
    .PARAMETER DisableInheritance
        Entfernt vererbte ACEs und setzt nur die definierten Regeln.
    .EXAMPLE
        Set-FSLogixNtfsPermission -Path 'D:\FSLogixShare\Profiles' -UsersGroup 'CONTOSO\FSLogix-Users' -DisableInheritance -Verbose
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$UsersGroup,

        [string]$AdminsGroup = 'BUILTIN\Administrators',

        [switch]$DisableInheritance
    )

    try {
        Write-Verbose "Lade ACL von '$Path'"
        $acl = Get-Acl -Path $Path

        if ($DisableInheritance) {
            Write-Verbose 'Deaktiviere Vererbung und entferne bestehende ACEs'
            $acl.SetAccessRuleProtection($true, $false)
            foreach ($existingRule in @($acl.Access)) {
                $acl.RemoveAccessRule($existingRule) | Out-Null
            }
        }

        # Users/Gruppe: Modify - This folder only
        $ruleUsers = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $UsersGroup,
            [System.Security.AccessControl.FileSystemRights]::Modify,
            [System.Security.AccessControl.InheritanceFlags]::None,
            [System.Security.AccessControl.PropagationFlags]::None,
            [System.Security.AccessControl.AccessControlType]::Allow
        )

        # CREATOR OWNER: Modify - Subfolders and files only
        $ruleCreatorOwner = New-Object System.Security.AccessControl.FileSystemAccessRule(
            'CREATOR OWNER',
            [System.Security.AccessControl.FileSystemRights]::Modify,
            ([System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit),
            [System.Security.AccessControl.PropagationFlags]::InheritOnly,
            [System.Security.AccessControl.AccessControlType]::Allow
        )

        # Administrators: Full Control - This folder, subfolders and files
        $ruleAdmins = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $AdminsGroup,
            [System.Security.AccessControl.FileSystemRights]::FullControl,
            ([System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit),
            [System.Security.AccessControl.PropagationFlags]::None,
            [System.Security.AccessControl.AccessControlType]::Allow
        )

        # SYSTEM: Full Control - This folder, subfolders and files
        $ruleSystem = New-Object System.Security.AccessControl.FileSystemAccessRule(
            'NT AUTHORITY\SYSTEM',
            [System.Security.AccessControl.FileSystemRights]::FullControl,
            ([System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit),
            [System.Security.AccessControl.PropagationFlags]::None,
            [System.Security.AccessControl.AccessControlType]::Allow
        )

        foreach ($rule in @($ruleUsers, $ruleCreatorOwner, $ruleAdmins, $ruleSystem)) {
            $acl.AddAccessRule($rule)
        }

        if ($PSCmdlet.ShouldProcess($Path, 'NTFS-Berechtigungen setzen (FSLogix)')) {
            Set-Acl -Path $Path -AclObject $acl
            Write-Verbose "Berechtigungen erfolgreich gesetzt auf '$Path'"
        }
    }
    catch {
        Write-Error "Fehler beim Setzen der ACL auf '$Path': $($_.Exception.Message)"
    }
}
