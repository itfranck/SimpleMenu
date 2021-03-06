function Get-ConsoleKeyDisplayText($inputObject) {
    [String]$PrintedKey = "[$inputObject]"
    switch ($inputObject.value__) {
        {$_ -in 48..57 -or $_ -in 65..90} {$PrintedKey = ([char]$_) ;break}
        37 {$PrintedKey = '˂';break}
        38 {$PrintedKey = '˄';break} 
        39 {$PrintedKey = '˃';break} 
        40 {$PrintedKey = '˅';break} 
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
    [scriptblock]$ScriptBlock,
    [Object[]]$ArgumentList)
        Process{
           $ScriptBlock.Invoke($ArgumentList)
    }
}
function Invoke-SMBoard {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/Invoke-SMBoard.md')]

    Param(
        [ValidateNotNull()][SMBoard]$Board
    )
$Board.Index =  $Board.DefaultIndex
$PageIndex = 0
$Board.Print()

  if (![console]::IsInputRedirected) { 
    while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}
  }


    while ($true) {
        if ([console]::IsInputRedirected) {
            $Line = Read-Host
            if ($Line.Length -eq 1) {
                $LineRaw = [System.ConsoleKey]([int][char]($Line.ToUpper()))
            }
            
        }
        else {
         [System.ConsoleKey]$LineRaw = ([Console]::ReadKey($true)).Key
        }



            Switch ($LineRaw) {
               ($Board.Previous) {
                if ($Board.CurrentActionBoard.Quit) {Return}
                        
                $Board.PreviousBoard();break}
               ($Board.Next) {$Board.NextBoard();break}
               ($Board.PreviousPageKey) {$Board.PreviousPage();break}
               ($Board.NextPageKey){$Board.NextPage();break}
               ([System.ConsoleKey]::Escape) {return}
               Default {
                if ($Board.CurrentActionBoard.Quit) {break}
                 $Board.CurrentActionBoard = $Board.ActionItems | where Key -eq $LineRaw
                 if ($Board.CurrentActionBoard -ne $null ) {
                    
                    $Board.Print()
                     break
                 }
               }
            }
    }


}
function Invoke-SMMenu {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/Invoke-SMMenu.md')]
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
            if ($Line.Length -eq 1) {
                $Line = [System.ConsoleKey]([int][char]($Line.ToUpper()))
            }
            
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
            $Menu.QuitKey = $Line
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
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/New-SMBoard.md')]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
        [INT]$DefaultIndex,
        [Switch]$UseTabs
    )

    $ALLKeys = New-Object System.Collections.ArrayList
    if ($ActionItems -ne $null) {
    $ALLKeys.AddRange(@($ActionItems | Select -ExpandProperty key))
}
    $Duplicates = $ALLKeys | Group-Object | where count -gt 1
    if ($Duplicates.Count -gt 0) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }
    
    $Board = New-Object -TypeName SMBoard -Property $PSBoundParameters
    if ([Console]::IsInputRedirected) {
        $Board.Previous = [System.ConsoleKey]([int][char]'A')
        $Board.Next = [System.ConsoleKey]([int][char]'D')
        $Board.PreviousPageKey = [System.ConsoleKey]([int][char]'W')
        $Board.NextPageKey = [System.ConsoleKey]([int][char]'S')
    }
    return $Board


}

function New-SMBoardItem {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/New-SMBoardItem.md')]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()] #No value
        [String]$Title,
        [scriptblock[]]$Pages,
        [System.ConsoleKey]$key,
        [SMMenu]$Menu,
        [Switch]$Quit,
        [Object[]]$ArgumentList
    )

     $Item = New-Object -TypeName 'SMBoardItem' -Property $PSBoundParameters

    Return $Item
}
function New-SMMenu {
    [cmdletbinding(HelpUri='https://github.com/itfranck/SimpleMenu/blob/master/Help/New-SMMenu.md')]
    Param(
        [String]$Title,
        [psobject[]]$Items,
        [psobject[]]$ActionItems,
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
            $Menu.ActionItems.Add((New-SMMenuItem -Key Escape -Quit))
        }
    }
    
    
    $Duplicates = @($AllKeys | Group-Object -Property key | Where Count -gt 1)
    if ($Duplicates -ne $null) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }

    $Menu.SetruntimeKeys()
    
    return $Menu
}
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
        if ($PSBoundParameters.ContainsKey('ForegroundColor')) {$PSBoundParameters.Add('ForegroundColorSet',$true)}
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
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/Set-SMOptions.md')]
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
    [System.ConsoleKey]$PreviousPageKey = [System.ConsoleKey]::UpArrow
    [System.ConsoleKey]$NextPageKey = [System.ConsoleKey]::DownArrow
    [System.Collections.Generic.List[psobject]]$Items
    [System.Collections.Generic.List[psobject]]$ActionItems
    [String]$Title
    [INT]$Index
    [INT]$DefaultIndex
    [bool]$UseTabs
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
    #˂˃˄˅
    $Arrow1 = '|˂'
    $Arrow2 = '˃|'
    $Arrow3 = ''
    if ($this.Index -gt 0 -or $this.CurrentActionBoard -ne $null)  {$Arrow1 = '˂'}
    if ($this.Index -lt $this.Items.Count -1 -and $this.CurrentActionBoard -eq $null) {$Arrow2 = '˃'}

    # The goal is to output something like this:
    #                                                 -----------------
    # |    Home    |    Builds    |    Deployments    |    Settings    |    Help    |
    # -------------------------------------------------                --------------

    $topRowStrings = @()
    $middleRowStrings = @()
    $bottomRowStrings = @()

    for($i = 0; $i -lt $this.Items.Count; $i += 1) {
        
        $padSize = 3
        $isSelected = $i -eq $this.Index
        $cellTitle = $this.Items[$i].Title
        $cellSize = $cellTitle.Length + 2 * $padSize # padding on each side
        $topChar = ' '; if ($isSelected) { $topChar = '-' }
        $topRowStrings += "".PadLeft($cellSize + 1, $topChar)
        $paddedTitle = $cellTitle.PadLeft($cellSize - $padSize, ' ').PadRight($cellSize, ' ')
        $middleRowStrings += "|$paddedTitle"
        $bottomChar = '-'; if ($isSelected) { $bottomChar = ' ' }
        $bottomRowStrings += "".PadLeft($cellSize + 1, $bottomChar)
    }

    $topRowString = $topRowStrings -join ''
    $middleRowString = $middleRowStrings -join ''
    $bottomRowString = $bottomRowStrings -join ''

        $tabs = @"
$topRowString
$middleRowString|
$bottomRowString
"@

    if ($CurrentItem.menu -ne $null) {
        $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
        $inIndent =   $CurrentItem.Menu.TitleIndent
        $inActionItems = $CurrentItem.Menu.ActionItems
        $InTitle = $CurrentItem.Menu.Title
        $CurrentItem.Menu.TitleIndent = ''
        
        $CurrentItem.Menu.Title = $OutTitle
        if ($this.UseTabs) { $CurrentItem.Menu.Title = $tabs }
        $QuitActionKey = [System.ConsoleKey]::LeftArrow
        $QuitAction1Key = [System.ConsoleKey]::RightArrow
        if ([Console]::IsInputRedirected) {
            $QuitActionKey = [System.ConsoleKey]::A
            $QuitAction1Key = [System.ConsoleKey]::D
        }
        $QuitAction = New-SMMenuItem -Key $QuitActionKey -Quit ; $QuitAction.RuntimeKey = $QuitActionKey
        $QuitAction1 = New-SMMenuItem -Key $QuitAction1Key -Quit ; $QuitAction1.RuntimeKey = $QuitAction1Key
        $CurrentItem.Menu.ActionItems+= $QuitAction
        $CurrentItem.Menu.ActionItems+= $QuitAction1        
        Invoke-SMMenu $CurrentItem.Menu
        $CurrentItem.menu.Title = $InTitle
        $CurrentItem.Menu.TitleIndent = $inIndent
        $CurrentItem.Menu.ActionItems = $inActionItems
        switch ($CurrentItem.Menu.QuitKey) {
            {$_ -in 'LeftArrow','A'} {$this.PreviousBoard() }
            {$_ -in 'RightArrow','D'} {$this.NextBoard()}
        }
        return
    }


        if ($CurrentItem.Pages.Count -gt 1) {
            $Arrow31 = '˅'
            $Arrow32 = '˄'
            
            switch ($CurrentItem.Index) {
                0 {$Arrow32 = '-' }
                {$_ -eq ($CurrentItem.Pages.Count -1)} {$Arrow31 = '-'}
            }
            $Arrow3 = " ($($Arrow31)$($Arrow32))"
        }

        if ($this.UseTabs) { 
            Write-Host $tabs -ForegroundColor Cyan 
        } else { 
            $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
            Write-Host $OutTitle  -ForegroundColor Cyan
        }
    
        $Arguments = @{} 
        $CurrentPage = $CurrentItem.Pages[$CurrentItem.Index]
        if ($CurrentItem.ArgumentList -ne $null) {
            $Arguments.Add('ArgumentList',$CurrentItem.ArgumentList[$CurrentItem.Index])
        }
    
        try {
            Write-host ($this | Invoke-CommandPiped @Arguments -ScriptBlock ([scriptblock]::Create($CurrentItem.Pages[$CurrentItem.Index])) | Out-String)
        }
        catch {
            Write-Error $_ -ErrorAction Continue
        }

        if (![Console]::IsInputRedirected) {
            while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}
        }
    }

    [Void]ChangeDisplayedItem([int]$index) {
        $this.Index = $index
        $this.Items[$this.Index].Index = 0
        $this.Print()
    }

[Void]PreviousBoard() {
    if ($this.CurrentActionBoard -ne $null) {
        $this.CurrentActionBoard.Index = 0
        $this.CurrentActionBoard = $null
        $this.Print()
    }
    elseif ($this.Index -gt 0)  {
        $this.ChangeDisplayedItem($this.Index - 1)
    }
    elseif ($this.Index -eq 0)  {
        $this.ChangeDisplayedItem($this.Items.Count-1)
    }
}

    [Void]NextBoard() {
        if ($this.CurrentActionBoard -eq $null) {

            if ($this.Index -lt $this.Items.Count -1)  {
                $this.ChangeDisplayedItem($this.Index + 1)
            } elseif ($this.Index -eq $this.Items.Count -1) {
                $this.ChangeDisplayedItem(0)
            }
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
    [Object[]]$ArgumentList

    
    
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
    [System.Collections.Generic.List[psobject]]$Items
    [System.Collections.Generic.List[psobject]]$ActionItems
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
        $AllItems.AddRange($this.Items)
        $AllItems.AddRange($this.ActionItems)

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
        if ($this.TitleForegroundColor -ne $null) {
            $TitleParams.Add('ForegroundColor', $this.TitleForegroundColor)
        }
       
        Write-Host "$($this.TitleIndent)$($this.Title)" @TitleParams
        
        $this.Items | % { 
            $ItemTitle =  "$(Get-ConsoleKeyDisplayText $_.runtimeKey). $($_.Title)"
            if ($_.Disabled) {
                Write-Host $ItemTitle -ForegroundColor DarkGray
            } else {
                $ForegroundParam = $null
                $ForegroundParam = @{}
               if ($_.ForegroundColorSet) {
                   $ForegroundParam.Add('ForegroundColor',$_.ForegroundColor)
               }
                Write-Host $ItemTitle @ForegroundParam
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
    hidden [Switch]$ForegroundColorSet
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
    [Object[]]$ArgumentList
}


