function Invoke-SimpleMenu {
    [cmdletbinding()]
    param(
        [ValidateNotNull()][SimpleMenu]$Menu

    )
    $Debug = ($psboundparameters.debug.ispresent -eq $true)

    [WarningMessages]$InvalidChoice = [WarningMessages]::None
    if (-not   $Debug ){Clear-Host}
    $Menu.Print()
    while ($true) {
      
        if ([console]::IsInputRedirected) {
            $Line = Read-Host
        }
        else {
            [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            $Line = $LineRaw.KeyChar.ToString()
        }
        $Result = @($Menu.Items | Where runtimeKey -eq $Line )
        

        if ($Result.Count -gt 0) {
            $ShouldPause = $Result.Pause
            if ($Result.Submenu -eq $null -or $Result.IsExit -eq $false ) {
                if (-not $Debug ){Clear-Host} ; $Menu.Print()
            }

            if ($Result.Action -ne $null) {
                try {
                    ($Result.Action).invoke()
                }
                catch {
                    Write-Error $_
                    $ShouldPause = $true
                }

                if ($ShouldPause -eq $true) {Pause;  if (-not $Debug ){Clear-Host} ; $Menu.Print()  }

            }
            else {
                if (-not ($Result.IsExit) -and ( $null -eq $Result.Submenu)) {
                    $InvalidChoice = [WarningMessages]::NoActionDefined
                }
            }

        }
        else {
            if (-not $Debug ){Clear-Host} ; $Menu.Print()
            $InvalidChoice = [WarningMessages]::InvalidChoice
        }

        if ($Result.Submenu -ne $Null) {
            $Result.Submenu.Parent = $Menu
            Invoke-SimpleMenu $Result.Submenu -debug:$Debug
        }

        if ($Result.IsExit -eq $true) {
            if ($Menu.Parent -ne $null) {
                if (-not   $Debug ){Clear-Host}
                $Menu.Parent.Print()
            }
            return
        }



        if ( ($InvalidChoice -ne [WarningMessages]::None) ) {
            Switch($InvalidChoice) {
                ([WarningMessages]::NoActionDefined) {  Write-Warning 'No actions have been defined for this menu item.'}
                ([WarningMessages]::InvalidChoice) {
                    Write-Warning "'$Line' is not a valid choice"
                    $IDs = ($menu.Items | Select-Object -ExpandProperty runtimeKey) -join ','
                    Write-Host "Valid choices are: $IDs"
                }
            }


            $InvalidChoice = [WarningMessages]::None
        }

    }

}


