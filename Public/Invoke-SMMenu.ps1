function Invoke-SMMenu {
    [cmdletbinding()]
    param(
        [ValidateNotNull()][SMMenu]$Menu,
        [Switch]$PassThru,
        [ValidateNotNullOrEmpty()]
        [String]$lang = 'en'

    )

    if ($lang -ne 'en') {
        init -lang $Lang
    }

    if ($PassThru) {$Menu.Print(); return}
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
            $Line = $LineRaw.Key
        }
        $Result = @($Menu.Items | Where runtimeKey -eq $Line )
        

        if ($Result.Count -gt 0) {
            $Result =$Result |select -First 1
            $ShouldPause = $Result.Pause
            if ($Result.Submenu -eq $null -or $Result.Quit -eq $false ) {
                if (-not $Debug ){Clear-Host} ; $Menu.Print()
            }

            if ($Result.Action -ne $null) {
                try {
                    # Need to recreate the received scriptblock otherwise the $_ variable does not work :(
                    $CurrentTitle = $Result.Title
                    $Result | Invoke-CommandPiped -ScriptBlock ([ScriptBlock]::Create(([String]$Result.Action)))
                }
                catch {
                    Write-Error $_
                    $ShouldPause = $true
                }

                if ($ShouldPause -eq $true) {Pause;  if (-not $Debug ){Clear-Host} ; $Menu.Print()  }

            }
            else {
                if (-not ($Result.Quit) -and ( $null -eq $Result.Submenu)) {
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
            Invoke-SMMenu $Result.Submenu 
        }

        if ($Result.Quit -eq $true) {
            if ($Menu.Parent -ne $null) {
                if (-not   $Debug ){Clear-Host}
                $Menu.Parent.Print()
            }
            return
        }



        if ( ($InvalidChoice -ne [WarningMessages]::None) ) {
            Switch($InvalidChoice) {
                ([WarningMessages]::NoActionDefined) {  Write-Warning $Messages.Warning_NoActions}
                ([WarningMessages]::InvalidChoice) {
                    Write-Warning ($Messages.Warning_InvalidChoice -f $Line)
                    $IDs = ($menu.Items.runtimeKey | % {Get-ConsolekeyDisplayText $_}) -join ','
                    Write-Host ($Messages.info_validChoices -f $IDs)
                }
            }


            $InvalidChoice = [WarningMessages]::None
        }

    }

}


