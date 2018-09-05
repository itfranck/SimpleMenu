function New-SMMenu {
    [cmdletbinding()]
    Param(
        [String]$Title,
        [SMMenuItem[]]$Items,
        [SMMenuItem[]]$ActionItems,
        [ConsoleColor]$TitleForegroundColor,
        [String]$Id
    )
    $Menu = New-Object -TypeName SMMenu
    $Menu.Title = $Title
    if ($PSBoundParameters.ContainsKey('TitleForegroundColor')) {
        $Menu.TitleForeGround = $TitleForegroundColor
    }

    $AllKeys = New-Object System.Collections.ArrayList

    Foreach ($AItem in $ActionItems) {
        if (-not [String]::IsNullOrWhiteSpace($AItem.Key)){
            if ($AllKeys.Contains($AItem.Key)) {
                Write-Error $Warning_KeyAlreadyAssigned
                return $null
                        }
                        else {
                            $AllKeys.Add($AItem.Key) | Out-Null
                        }
        }

        $Menu.ActionItems.Add($AItem)
    }


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
