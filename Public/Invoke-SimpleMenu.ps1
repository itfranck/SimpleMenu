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


            $InvalidChoice = [WarningMessages]::None
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
                if (-not ($Result.IsExit) -and ( $null -eq $Result.Submenu)) {
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


