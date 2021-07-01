function Invoke-SMMenu {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/Invoke-SMMenu.md')]
    param(
        [ValidateNotNull()][SMMenu]$Menu,
        [Switch]$PassThru
    )

    if ($PassThru) { $Menu.Print(); return }
    $Debug = ($psboundparameters.debug.ispresent -eq $true)

    [WarningMessages]$InvalidChoice = [WarningMessages]::None
    if (-not   $Debug ) { Clear-Host }
    $Menu.Print()
    
    while ($true) {
      
        if ([console]::IsInputRedirected) {
            $Line = Read-Host
            if ($Line.Length -eq 1) {
                $Line = [System.ConsoleKey]([int][char]($Line.ToUpper()))
            }
            
        }
        else {
            [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            $Line = $LineRaw.Key
        }
        $Result = @($Menu.Items | Where { $_.runtimeKey -eq $Line -and -not $_.Disabled } )
        if ($Result.Count -eq 0) {
            $Result = @($Menu.ActionItems | Where { $_.runtimeKey -eq $Line -and -not $_.Disabled })
        }

        if ($Result.Count -gt 0) {
            $Result = $Result | select -First 1
            $ShouldPause = $Result.Pause
            if ($Result.Submenu -eq $null -or $Result.Quit -eq $false ) {
                if (-not $Debug ) { Clear-Host } ; $Menu.Print()
            }

            if ($Result.Action -ne $null) {
                try {
                    # Need to recreate the received scriptblock otherwise the $_ variable does not work :(
                    if ($Result.Detailed) {
                        $BoardItem = New-SMBoardItem -Title $Result.Title -Pages $Result.Action -Quit -ArgumentList $result.ArgumentList
                        $Board = New-SMBoard  -Title $Menu  -ActionItems $BoardItem 
                        $Board.CurrentActionBoard = $BoardItem 
                        Invoke-SMBoard $Board 
                        Clear-Host
                        $Menu.Print()
                    }
                    else {
                        
                        $Result | Invoke-CommandPiped -ScriptBlock ([ScriptBlock]::Create(([String]$Result.Action))) -ArgumentList $Result.ArgumentList
                    }

                    
                }
                catch {
                    Write-Error $_ -ErrorAction Continue
                    $ShouldPause = $true
                }

                if ($ShouldPause -eq $true) { Pause; if (-not $Debug ) { Clear-Host } ; $Menu.Print() }

            }
            else {
                if (-not ($Result.Quit) -and ( $null -eq $Result.Submenu)) {
                    $InvalidChoice = [WarningMessages]::NoActionDefined
                }
            }

        }
        else {
            if (-not $Debug ) { Clear-Host } ; $Menu.Print()
            $InvalidChoice = [WarningMessages]::InvalidChoice
        }

        if ($Result.Submenu -ne $Null) {
            $Result.Submenu.Parent = $Menu
            Invoke-SMMenu $Result.Submenu 
        }

        if ($Result.Quit -eq $true) {
            if ($Menu.Parent -ne $null) {
                if (-not   $Debug ) { Clear-Host }
                $Menu.Parent.Print()
            }
            $Menu.QuitKey = $Line
            return
        }



        if ( ($InvalidChoice -ne [WarningMessages]::None) ) {
            Switch ($InvalidChoice) {
                ([WarningMessages]::NoActionDefined) { Write-Warning $Messages.Warning_NoActions }
                ([WarningMessages]::InvalidChoice) {
                    Write-Warning ($Messages.Warning_InvalidChoice -f (Get-ConsolekeyDisplayText $Line))
                    $IDs = ($menu.Items.runtimeKey | % { Get-ConsolekeyDisplayText $_ }) -join ','
                    Write-Host ($Messages.info_validChoices -f $IDs)
                }
            }


            $InvalidChoice = [WarningMessages]::None
        }

    }

}


