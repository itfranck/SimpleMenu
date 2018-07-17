function New-SimpleMenuItem {
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
        [Switch]$NoPause,
        $Submenu
    

    )
    Begin {
        $MenuItem = New-Object  PSObject -Property  @{
            'Title'      = ''
            'Id'         = ''
            'Key'        = ''
            'runtimeKey' = ''
            Action       = ''
            IsExit       = $false
            Submenu      = $Null
            NoPause = $NoPause
        }
        
        $WriteHostParams = @{}
        if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
            $WriteHostParams.add('ForegroundColor', $ForegroundColor)
        }

        $MenuItem.Id = $Id
        $MenuItem.Key = $Key
        $MenuItem.Action = $Action
        $MenuItem.IsExit = $Quit
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
