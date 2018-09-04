function New-SMMenu {
    [cmdletbinding()]
    Param(
        [String]$Title,
        [SMMenuItem[]]$Items, 
        [ConsoleColor]$TitleForegroundColor,
        [String]$Id
    )
    $Menu = New-Object -TypeName SMMenu
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