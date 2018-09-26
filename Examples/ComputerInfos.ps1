#Remove-Module SimpleMenu
Import-Module '.\..\SimpleMenu.psm1' -Force


Function Get-BaseInfos() {
    [System.Collections.Generic.List[psobject]]$Results = Get-NetIPAddress |  Where {$_.AddressState -EQ 'Preferred' -and $_.IPAddress -ne $null -and $_.IPAddress -ne '127.0.0.1' } | Sort-Object -Property PrefixOrigin -Descending | Select IPAddress,InterfaceAlias
$Results.Add(([PSCustomObject]@{'IPAddress'=$ipinfo.ip ;'InterfaceAlias'='External IP'}))
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
    [System.Collections.Generic.List[psobject]]$Results = Get-NetIPAddress |  Where {$_.AddressState -EQ 'Preferred' -and $_.IPAddress -ne $null -and $_.IPAddress -ne '127.0.0.1' } | Sort-Object -Property PrefixOrigin -Descending | Select IPAddress,InterfaceAlias
    $Results.Add(([PSCustomObject]@{'IPAddress'=$ipinfo.ip ;'InterfaceAlias'='External IP'}))
    

    $disk = Get-WmiObject Win32_LogicalDisk  | Where DriveType -EQ 3
    
    $DiskOutput = $disk | Select DeviceID,
                        @{n='Free %';e={[Math]::Round(($_.FreeSpace / $_.Size)*100,2)}},
                        @{n='Free GB';e={[Math]::Round(($_.FreeSpace / 1gb),2)}},
                        @{n='Total Space';e={[Math]::Round(($_.Size / 1gb),2)}}

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

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$options = New-SMMenu -Title 'Quick actions' -Items @(
    New-SMMenuItem -Title 'Empty all recycle bins' -Action {}
    New-SMMenuItem -Title 'Back' -Quit -Key B
) -ActionItems @(
    New-SMMenuItem -Title 'Back' -Quit -Key Escape
)


$Menu = New-SMMenu -Title 'Computers infos' -Items @(
    New-SMMenuItem -Title 'Computer informations' -Detailed -Action {Get-ComputerInfos}
    New-SMMenuItem -Title 'IP Address' -Detailed -Action { Get-BaseInfos}
    New-SMMenuItem -Title 'Quick actions' -Submenu $options
)



Invoke-SMMenu $Menu


    
