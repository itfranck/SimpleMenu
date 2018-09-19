function Get-ConsoleKeyDisplayText($inputObject) {
    [String]$PrintedKey = "[$inputObject]"
    switch ($inputObject.value__) {
        {$_ -in 48..57 -or $_ -in 65..90} {$PrintedKey = ([char]$_) ;break}
        37 {$PrintedKey = '◀';break}
        38 {$PrintedKey = '▲';break} 
        39 {$PrintedKey = '▶';break} 
        40 {$PrintedKey = '▼';break} 
        Default {}
    }


    return $PrintedKey


}
function init($lang = 'en') {
    Import-LocalizedData -BindingVariable Messages -BaseDirectory "$ModuleRoot\lang"  -FileName 'strings' -UICulture $Language
    $Script:Messages = $Messages
}
if ($ModuleRoot -eq $null) {$ModuleRoot = $PSScriptRoot}
init

function Invoke-CommandPiped {
    [cmdletbinding()]
    Param([Parameter(ValueFromPipeline=$true)]$InputObject,
    [scriptblock]$ScriptBlock)
        Process{
            $ScriptBlock.Invoke($InputObject)
    }
}
function Invoke-SMBoard {
    [cmdletbinding()]

    Param(
        [ValidateNotNull()][SMBoard]$Board
    )
$Board.Index =  $Board.DefaultIndex
$PageIndex = 0
$Board.Print()

while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}

    while ($true) {
         [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            Switch ($LineRaw.Key) {
               ($Board.Previous) {
                if ($Board.CurrentActionBoard.Quit) {Return}
                        
                $Board.PreviousBoard();break}
               ($Board.Next) {$Board.NextBoard();break}
               ([System.ConsoleKey]::UpArrow) {$Board.PreviousPage();break}
               ([System.ConsoleKey]::DownArrow){$Board.NextPage();break}
               ([System.ConsoleKey]::Escape) {return}
               Default {
                if ($Board.CurrentActionBoard.Quit) {break}
                 $Board.CurrentActionBoard = $Board.ActionItems | where Key -eq $LineRaw.Key
                 if ($Board.CurrentActionBoard -ne $null ) {
                    
                    $Board.Print()
                     break
                 }
               }
            }
    }


}
function Invoke-SMMenu {
    [cmdletbinding()]
    param(
        [ValidateNotNull()][SMMenu]$Menu,
        [Switch]$PassThru
    )

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
        $Result = @($Menu.Items | Where {$_.runtimeKey -eq $Line -and -not $_.Disabled } )
        if ($Result.Count -eq 0) {
            $Result = @($Menu.ActionItems | Where {$_.runtimeKey -eq $Line -and -not $_.Disabled })
        }

        if ($Result.Count -gt 0) {
            $Result =$Result |select -First 1
            $ShouldPause = $Result.Pause
            if ($Result.Submenu -eq $null -or $Result.Quit -eq $false ) {
                if (-not $Debug ){Clear-Host} ; $Menu.Print()
            }

            if ($Result.Action -ne $null) {
                try {
                    # Need to recreate the received scriptblock otherwise the $_ variable does not work :(
                    if ($Result.Detailed) {
                        $BoardItem = New-SMBoardItem -Title $Result.Title -Pages $Result.Action -Quit
                        $Board = New-SMBoard  -Title $Menu  -ActionItems $BoardItem 
                        $Board.CurrentActionBoard = $BoardItem 
                        Invoke-SMBoard $Board 
                        Clear-Host
                        $Menu.Print()
                    }
                    else {
                        $Result | Invoke-CommandPiped -ScriptBlock ([ScriptBlock]::Create(([String]$Result.Action)))
                    }

                    
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
            $Menu.QuitKey = $LineRaw.Key
            return
        }



        if ( ($InvalidChoice -ne [WarningMessages]::None) ) {
            Switch($InvalidChoice) {
                ([WarningMessages]::NoActionDefined) {  Write-Warning $Messages.Warning_NoActions}
                ([WarningMessages]::InvalidChoice) {
                    Write-Warning ($Messages.Warning_InvalidChoice -f (Get-ConsolekeyDisplayText $Line))
                    $IDs = ($menu.Items.runtimeKey | % {Get-ConsolekeyDisplayText $_}) -join ','
                    Write-Host ($Messages.info_validChoices -f $IDs)
                }
            }


            $InvalidChoice = [WarningMessages]::None
        }

    }

}


function New-SMBoard {
    [cmdletbinding()]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
        [INT]$DefaultIndex
    )

    $ALLKeys = New-Object System.Collections.ArrayList
    if ($ActionItems -ne $null) {
    $ALLKeys.AddRange(@($ActionItems | Select -ExpandProperty key))
}
    $Duplicates = $ALLKeys | Group-Object | where count -gt 1
    if ($Duplicates.Count -gt 0) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }
    


    return New-Object -TypeName SMBoard -Property $PSBoundParameters


}

function New-SMBoardItem {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()] #No value
        [String]$Title,
        [scriptblock[]]$Pages,
        [System.ConsoleKey]$key,
        [SMMenu]$Menu,
        [Switch]$Quit
    )

     $Item = New-Object -TypeName 'SMBoardItem' -Property $PSBoundParameters

    Return $Item
}
function New-SMMenu {
    [cmdletbinding()]
    Param(
        [String]$Title,
        [SMMenuItem[]]$Items,
        [SMMenuItem[]]$ActionItems,
        [ConsoleColor]$TitleForegroundColor
    )
    $Menu = New-Object -TypeName SMMenu -Property $PSBoundParameters
 
    $AllKeys = New-Object System.Collections.ArrayList

    $AllKeys.AddRange(@($Items | where key -NE $null))
    $AllKeys.AddRange(@($ActionItems | where key -NE $null ))

    $HasExit = $Items | where Quit -eq $true
    if ($HasExit -eq $null) {
        $HasExit = $ActionItems | where Quit -eq $true
    }
    if ($HasExit -eq $null) {
        $Cando = ($AllKeys | where Key -EQ ([System.ConsoleKey]::Escape)) -eq $null
        if ($Cando) {
            $Menu.ActionItems += New-SMMenuItem -Key Escape -Quit
        }
    }
    
    
    $Duplicates = @($AllKeys | Group-Object -Property key | Where Count -gt 1)
    if ($Duplicates -ne $null) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }

    $AllItems = $Items + $ActionItems 
    $Menu.SetruntimeKeys()
    
    return $Menu
}
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
        [psobject]$Submenu,
        [Switch]$Detailed,
        [Switch]$Disabled
    

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
function Set-SMOptions {
    [CMDLetBinding()]
    Param(
        $Language = 'en'
    )

    if ($PSBoundParameters.ContainsKey('Language')) {
        Import-LocalizedData -BindingVariable Messages -BaseDirectory "$($ModuleRoot)\lang"  -FileName 'strings' -UICulture $Language
        $Script:Messages = $Messages
    }

} 
class SMBoard {
    [System.ConsoleKey]$Previous = [System.ConsoleKey]::LeftArrow
    [System.ConsoleKey]$Next = [System.ConsoleKey]::RightArrow
    [psobject[]]$Items
    [psobject[]]$ActionItems
    [String]$Title
    [INT]$Index
    [INT]$DefaultIndex
    [psobject]$CurrentActionBoard = $null

        


    [Void]Print() {
    #    ▲△▴▵     ▶▷▸▹ ▼▽▾▿ ◀◁◂◃
    Clear-Host

    if ($this.CurrentActionBoard -ne $null) {
        $CurrentItem = $this.CurrentActionBoard
    }
    else {
        $CurrentItem = $this.Items[$this.Index]
    }
    
    $Arrow1 = '◁'
    $Arrow2 = '▷'
    $Arrow3 = ''
    if ($this.Index -gt 0 -or $this.CurrentActionBoard -ne $null)  {$Arrow1 = '◀'}
    if ($this.Index -lt $this.Items.Count -1 -and $this.CurrentActionBoard -eq $null) {$Arrow2 = '▶'}


    if ($CurrentItem.menu -ne $null) {
        $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
        $inIndent =   $CurrentItem.Menu.TitleIndent
        $inActionItems = $CurrentItem.Menu.ActionItems
        $InTitle = $CurrentItem.Menu.Title
        $CurrentItem.Menu.TitleIndent = ''
        $CurrentItem.Menu.Title = $OutTitle
        $QuitAction = New-SMMenuItem -Key LeftArrow -Quit ; $QuitAction.RuntimeKey = [System.ConsoleKey]::LeftArrow
        $QuitAction1 = New-SMMenuItem -Key RightArrow -Quit ; $QuitAction1.RuntimeKey = [System.ConsoleKey]::RightArrow

        if ($this.Index -gt 0 -or $this.CurrentActionBoard -ne $null)  {$CurrentItem.Menu.ActionItems+= $QuitAction}
        if ($this.Index -lt $this.Items.Count -1 -and $this.CurrentActionBoard -eq $null) {$CurrentItem.Menu.ActionItems+= $QuitAction1}

        
                      
        

        Invoke-SMMenu $CurrentItem.Menu
        $CurrentItem.menu.Title = $InTitle
        $CurrentItem.Menu.TitleIndent = $inIndent
        $CurrentItem.Menu.ActionItems = $inActionItems
        switch ($CurrentItem.Menu.QuitKey) {
            LeftArrow {$this.PreviousBoard() }
            RightArrow {$this.NextBoard()}
        }
        return
    }


    if ($CurrentItem.Pages.Count -gt 1) {
        $Arrow31 = '▼'
        $Arrow32 = '▲'
        
        switch ($CurrentItem.Index) {
            0 {$Arrow32 = '△' }
            {$_ -eq ($CurrentItem.Pages.Count -1)} {$Arrow31 = '▽'}
        }
        $Arrow3 = " ($($Arrow31)$($Arrow32))"
    }

    $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
    Write-Host $OutTitle  -ForegroundColor Cyan
    Write-host ($this | Invoke-CommandPiped -ScriptBlock ([scriptblock]::Create($CurrentItem.Pages[$CurrentItem.Index])) | Out-String)
    while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}
    }

[Void]PreviousBoard() {
    if ($this.CurrentActionBoard -ne $null) {
        $this.CurrentActionBoard.Index = 0
        $this.CurrentActionBoard = $null
        $this.Print()
    }
    elseif ($this.Index -gt 0)  {
        $this.Index -=1
        $this.Items[$this.Index].Index = 0
        $this.Print()
    }
    
}

   

    [Void]NextBoard() {
        if ($this.Index -lt $this.Items.Count -1 -and $this.CurrentActionBoard -eq $null)  {
            $this.Index +=1
            $this.Items[$this.Index].Index = 0
            $this.Print()
        }
    }

    [Void]PreviousPage() {
        if ($this.CurrentActionBoard -ne $null -and $this.CurrentActionBoard.PreviousPage()) {
            $this.Print()
        }
        elseif ($this.Items -ne $null -and $this.Items[$this.Index].PreviousPage()) {
            $this.Print()
        }

    }

    [Void]NextPage() {
        if ($this.CurrentActionBoard -ne $null -and $this.CurrentActionBoard.NextPage()) {
            $this.Print()
        }
        elseif($this.items -ne $null -and  $this.Items[$this.Index].NextPage()) {
            $this.Print()
        }
    }

}
class SMBoardItem {
    [scriptblock[]]$Pages
    [scriptblock]$Action
    [System.ConsoleKey]$Key
    [Switch]$Return
    [int]$CurrentIndex
    [String]$Title
    [int]$Index
    [psobject]$Menu
    [Switch]$Quit

    
    [Bool]PreviousPage() {
        if ($this.Index -gt 0) {
            $this.Index-=1
            return $true
        }
        return $false
    }
    [Bool]NextPage() {
        if ($this.Index -lt $this.Pages.Count -1) {
            $this.Index+=1
            return $true
        }
        return $false
    }
}
class SMMenu {
    [PSObject[]]$Items
    [PSObject[]]$ActionItems
    [String]$Title
    [ConsoleColor]$TitleForegroundColor = [ConsoleColor]::Cyan
    [SMMenu]$Parent = $null
    hidden [System.Collections.ArrayList]$runtimeKeys
    hidden [int]$runtimeKeyIndex
    hidden [String] $TitleIndent = '   '
    hidden [ConsoleKey]$QuitKey
    SMMenu() {
        $This.Items = New-Object System.Collections.Generic.List[PSObject]
        $This.ActionItems = New-Object System.Collections.Generic.List[PSObject]

        $This.runtimeKeys = New-Object System.Collections.ArrayList
        $AvailablesChar = @(49..57) + @(48) + @(65..90) | % {[System.ConsoleKey]($_)}
        $This.runtimeKeys.AddRange($AvailablesChar)
        
    }

    [PSObject]GetItem($id) {
        $out = ($this.Items | Where-Object {$_.ID -eq $ID} | Select -First 1)
        return $out
    }

    hidden[void]SetruntimeKeys() {
        $AvailableKeys = New-Object System.Collections.ArrayList 
        $AvailableKeys.AddRange($this.runtimeKeys)
        
        $AllItems = New-Object 'System.Collections.Generic.List[psobject]'
        $AllItems.AddRange($this.Items);$AllItems.AddRange($this.ActionItems)
        $AssignedKeys = $AllItems | Where key -NE $null 
        $AssignedKeys | % {$AvailableKeys.Remove($_.key);$_.runtimeKey = $_.key}

        $EmptyKeys = $AllItems | Where key -eq $null
        Foreach ($key in $EmptyKeys ) {
            $key.runtimeKey = [System.ConsoleKey]($AvailableKeys[$this.runtimeKeyIndex])
            $this.runtimeKeyIndex++
        }

        
    }

    

    Print() {
        $TitleParams = @{}
        $TitleParams.Add('ForegroundColor', $this.TitleForegroundColor)
       
        Write-Host "$($this.TitleIndent)$($this.Title)" @TitleParams
        
        $this.Items | % { 
            $ItemTitle =  "$(Get-ConsoleKeyDisplayText $_.runtimeKey). $($_.Title)"
            if ($_.Disabled) {
                Write-Host $ItemTitle -ForegroundColor DarkGray
            } else {
                Write-Host $ItemTitle
            }
         }
    }
}

enum WarningMessages{
    Undefined
    None
    InvalidChoice
    NoActionDefined
}
class SMMenuItem {
    [ScriptBlock]$Action = $null
    [System.ConsoleColor]$ForegroundColor
    [String]$Id
    $Key = $null
    [SMMenu]$Parent = $null
    [Switch]$Pause
    [Switch]$Quit
    [SMMenu]$Submenu
    [String]$Title
    $runtimeKey
    [Switch]$Detailed
    [Switch]$Disabled
}


