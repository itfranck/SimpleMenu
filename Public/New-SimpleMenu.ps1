function New-SimpleMenu($Title, $Items, [ConsoleColor]$TitleForegroundColor, $Id) {
    $Menu = New-Object -TypeName SimpleMenu
    $Menu.Title = $Title
    if ($PSBoundParameters.ContainsKey('TitleForegroundColor')) {
        $Menu.TitleForeGround = $TitleForegroundColor
    }

    $AllKeys = New-Object System.Collections.ArrayList
    Foreach ($Item in $Items) {
        if (-not [String]::IsNullOrWhiteSpace($item.Key)){
            if ($AllKeys.Contains($Item.Key)) {
                Write-Error "The key $($item.key) is already assigned to another element of this menu and cannot be assigned to item $($item.Title)."
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
