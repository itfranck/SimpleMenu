function New-SMMenuItem {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/New-SMMenuItem.md')]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()] #No value
        [String]$Title,
        [System.ConsoleColor]$ForegroundColor,
        $Id, 
        [System.ConsoleKey]$Key,
        [ScriptBlock]$Action = $null,
        [Switch]$Quit,
        [Switch]$Pause,
        [psobject]$Submenu,
        [Switch]$Detailed,
        [Switch]$Disabled,
        [Object[]]$ArgumentList
    )
    Begin {
        if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $PSBoundParameters.Add('ForegroundColorSet', $true) }
        $MenuItem = New-Object -TypeName SMMenuItem -Property $PSBoundParameters
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
