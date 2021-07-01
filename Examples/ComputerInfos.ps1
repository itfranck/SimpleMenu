﻿Get-Module SimpleMenu | Remove-Module
Import-Module SimpleMenu
#Import-Module "$Script:PSScriptRoot\..\SimpleMenu.psm1" -Force

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

Function Get-BaseInfos() {
    [System.Collections.Generic.List[psobject]]$Results = Get-NetIPAddress |  Where { $_.AddressState -EQ 'Preferred' -and $_.IPAddress -ne $null -and $_.IPAddress -ne '127.0.0.1' } | Sort-Object -Property PrefixOrigin -Descending | Select IPAddress, InterfaceAlias
    $Results.Add(([PSCustomObject]@{'IPAddress' = $ipinfo.ip ; 'InterfaceAlias' = 'External IP' }))
    $ipinfo = Invoke-RestMethod http://ipinfo.io/json 



    $Results | ft -AutoSize
    '---'

    $ipinfo.hostname 
    $ipinfo.city 
    $ipinfo.region 
    $ipinfo.country 
    $ipinfo.loc 
    $ipinfo.org


}

Function Get-ComputerInfos() {
    $ipinfo = Invoke-RestMethod http://ipinfo.io/json 
    [System.Collections.Generic.List[psobject]]$Results = Get-NetIPAddress |  Where { $_.AddressState -EQ 'Preferred' -and $_.IPAddress -ne $null -and $_.IPAddress -ne '127.0.0.1' } | Sort-Object -Property PrefixOrigin -Descending | Select IPAddress, InterfaceAlias
    $Results.Add(([PSCustomObject]@{'IPAddress' = $ipinfo.ip ; 'InterfaceAlias' = 'External IP' }))
    

    $disk = Get-WmiObject Win32_LogicalDisk  | Where DriveType -EQ 3
    
    $DiskOutput = $disk | Select DeviceID,
    @{n = 'Free %'; e = { [Math]::Round(($_.FreeSpace / $_.Size) * 100, 2) } },
    @{n = 'Free GB'; e = { [Math]::Round(($_.FreeSpace / 1gb), 2) } },
    @{n = 'Total Space'; e = { [Math]::Round(($_.Size / 1gb), 2) } }

    return @"
Computer name:          $($env:COMPUTERNAME)
Domain:                 $($env:USERDOMAIN)
Username:               $($env:USERNAME)
Version:                $([Environment]::OSVersion.VersionString)
PSVersion:              $($PSVersionTable.PSVersion)
---
$($DiskOutput | Out-String)
---
IP addresses
$($Results | Out-String)
"@
}

$AboutOut = @"
Demonstration sample console application made using SimpleMenu. 
———


"@


$options = New-SMMenu -Title 'Quick actions' -Items @(
    'Empty all recycle bins'                    | New-SMMenuItem -Title -Action { Write-Host 'Clearing all recycle bins...' -ForegroundColor Cyan; Clear-RecycleBin -Force; Write-Host 'Done!' -ForegroundColor Green }
    'Back'                                      | New-SMMenuItem -Quit -Key B
) -ActionItems @(
    'Back'                                      | New-SMMenuItem -Quit -Key Escape
)


$Menu = New-SMMenu -Title 'Computers infos' -Items @(
    'Computer informations'                     | New-SMMenuItem -Detailed -Action ${function:Get-ComputerInfos}
    'IP Address'                                | New-SMMenuItem -Title -Detailed -Action ${function:Get-BaseInfos}
    'Quick actions'                             | New-SMMenuItem -Submenu $options
    'About'                                     | New-SMMenuItem -Title -Key Z -ForegroundColor Yellow -Action { Param($AboutOut) "$AboutOut" } -Detailed -ArgumentList $AboutOut
    'Quit'                                      | New-SMMenuItem -Title  -Key X -Quit
    
    
) -ActionItems @(
    'Quit'                                      | New-SMMenuItem -Key Escape -Quit
)

Invoke-SMMenu $Menu 


