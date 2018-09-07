function New-SMMenu {
    [cmdletbinding()]
    Param(
        [String]$Title,
        [SMMenuItem[]]$Items,
        [SMMenuItem[]]$ActionItems,
        [ConsoleColor]$TitleForegroundColor
    )
    $Menu = New-Object -TypeName SMMenu -Property $PSBoundParameters
 
    $AllKeys = New-Object System.Collections.ArrayList

    $AllKeys.AddRange(@($Items | where key -NE $null))
    $AllKeys.AddRange(@($ActionItems | where key -NE $null ))

    
    $Duplicates = @($AllKeys | Group-Object -Property key | Where Count -gt 1)
    if ($Duplicates -ne $null) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }

    $AllItems = $Items + $ActionItems 
    $Menu.SetruntimeKeys()
    
    return $Menu
}
