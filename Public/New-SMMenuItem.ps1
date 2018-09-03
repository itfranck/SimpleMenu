function New-SMMenuItem {
    [cmdletbinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()] #No value
        [String]$Title,
        [System.ConsoleColor]$ForegroundColor,
        $Id, 
        [ValidatePattern('^[a-zA-Z]$')]$Key = $null,
        [ScriptBlock]$Action = $null,
        [Switch]$Quit,
        [Switch]$Pause,
        [psobject]$Submenu
    

    )
    Begin {
        $MenuItem = New-Object -TypeName SMMenuItem
        
        if ($PSBoundParameters.ContainsKey('ForegroundColor')) {$MenuItem.ForegroundColor = $ForegroundColor }

        $MenuItem.Id = $Id
        $MenuItem.Key = $Key
        $MenuItem.Action = $Action
        $MenuItem.Quit = $Quit
        $MenuItem.Submenu = $Submenu

    }
    Process {
        
        if ($_ -eq $null) {
            $_ = $Title
        }
        $MenuItem.Title = $_ 
        
    }     
    End {
        return $MenuItem
    }

}
