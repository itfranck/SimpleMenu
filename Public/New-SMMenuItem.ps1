function New-SMMenuItem {
    [cmdletbinding()]
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
        [psobject]$Submenu
    

    )
    Begin {
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
