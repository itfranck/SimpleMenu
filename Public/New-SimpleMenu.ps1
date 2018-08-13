function New-SimpleMenu {
    [cmdletbinding()]
    Param(
        [String]$Title,
        [SimpleMenuItem[]]$Items, 
        [ConsoleColor]$TitleForegroundColor,
        [String]$Id
    )
    $Menu = New-Object -TypeName SimpleMenu
    $Menu.Title = $Title
    if ($PSBoundParameters.ContainsKey('TitleForegroundColor')) {
        $Menu.TitleForeGround = $TitleForegroundColor
    }

    $AllKeys = New-Object System.Collections.ArrayList
    Foreach ($Item in $Items) {
        if (-not [String]::IsNullOrWhiteSpace($item.Key)){
            if ($AllKeys.Contains($Item.Key)) {
                Write-Error $Warning_KeyAlreadyAssigned
                return $null
                        }
                        else {
                            $AllKeys.Add($Item.Key) | Out-Null
                        }
        }

        $Menu.Items.Add($Item)
    }


    return $Menu
}
