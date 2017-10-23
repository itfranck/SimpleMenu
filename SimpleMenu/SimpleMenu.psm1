class SimpleMenu {
    [System.Collections.Generic.List[PSObject]]$Items
    [String]$Title
    [ConsoleColor]$TitleForeGround = [ConsoleColor]::Cyan


    SimpleMenu() {
        $This.Items = New-Object System.Collections.Generic.List[PSObject]
    }

    [PSObject]GetItem($id) {
        $out = ($this.Items | Where-Object {$_.ID -eq $ID} | Select -First 1)
        return $out
    }

    Print() {
        $TitleParams = @{}
        $TitleParams.Add('ForegroundColor', $this.TitleForeGround)
       
        Write-Host "   $($this.Title)" @TitleParams

        $NumberIndex = 0 
        Foreach ($Item in $this.Items) {
   
            if (-not [String]::IsNullOrWhiteSpace($Item.Key)) {
                $item.runtimeKey = $item.Key
            }
            else {
               $NumberIndex++
               $item.runtimeKey = $NumberIndex
        
            }
            Write-host "$($item.runtimeKey). $($Item.Title)"
        }

    }
}

enum WarningMessages{
    Undefined
    None
    InvalidChoice
    NoActionDefined
}



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
                        }
                        else {
                            $AllKeys.Add($Item.Key) | Out-Null
                        }
        }

        $Menu.Items.Add($Item)    
    }


    
    
    return $Menu
}


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


function Invoke-SimpleMenu {
    [cmdletbinding()]
    param(
        [SimpleMenu]$Menu
    )
    $Debug = ($psboundparameters.debug.ispresent -eq $true)
    
    [WarningMessages]$InvalidChoice = [WarningMessages]::None
    while ($true) {
        if (-not   $Debug ){Clear-Host}
        
        $Menu.Print()
        if (-not ($InvalidChoice -eq [WarningMessages]::None) ) {
            Switch($InvalidChoice) {
                ([WarningMessages]::NoActionDefined) {  Write-Warning 'No actions have been defined for this menu item.'}
                ([WarningMessages]::InvalidChoice) {
                    Write-Warning "'$Line' is not a valid choice"
                    $IDs = ($menu.Items | Select-Object -ExpandProperty runtimeKey) -join ','
                    Write-Host "Valid choices are: $IDs"
                }
            }

            
            $InvalidChoice = [WarningMessages]::Undefined
        }

        if ([console]::IsInputRedirected) {
            $Line = Read-Host
        }
        else {
            [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            $Line = $LineRaw.KeyChar.ToString()
        }
        
        
        $Result = @($Menu.Items | Where runtimeKey -eq $Line )

               
               
        if ($Result.Count -gt 0) {
            $ShouldNotPause = $Result.NoPause

            if ($InvalidChoice -eq [WarningMessages]::Undefined) {
                if (-not   $Debug ){Clear-Host}
                $Menu.Print()
                
                $InvalidChoice = [WarningMessages]::None
            }
            
            if ($Result.Action -ne $null) {
                try {
                    ($Result.Action).invoke()
                }
                catch {
                    Write-Error $_
                    $ShouldNotPause = $false
                }
                
                if ($ShouldNotPause -eq $false) {Pause}

            }
            else {
                if (-not ($Result.IsExit) -and ($Result.Submenu -eq $null)) {
                    $InvalidChoice = [WarningMessages]::NoActionDefined
                }
            }

        }
        else {
            $InvalidChoice = [WarningMessages]::InvalidChoice
        }

        if ($Result.Submenu -ne $Null) {
            Invoke-SimpleMenu $Result.Submenu -debug:$Debug
        }
        
        if ($Result.IsExit -eq $true) {
            return
        }
        
    }
        
    

    

    
}


