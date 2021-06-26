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


    if ($CurrentItem.menu -ne $null) {
        $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
        $inIndent =   $CurrentItem.Menu.TitleIndent
        $inActionItems = $CurrentItem.Menu.ActionItems
        $InTitle = $CurrentItem.Menu.Title
        $CurrentItem.Menu.TitleIndent = ''
        $CurrentItem.Menu.Title = $OutTitle

        $QuitActionKey = [System.ConsoleKey]::LeftArrow
        $QuitAction1Key = [System.ConsoleKey]::RightArrow
        if ([Console]::IsInputRedirected) {
            $QuitActionKey = [System.ConsoleKey]::A
            $QuitAction1Key = [System.ConsoleKey]::D
        }

        $QuitAction = New-SMMenuItem -Key $QuitActionKey -Quit ; $QuitAction.RuntimeKey = $QuitActionKey
        $QuitAction1 = New-SMMenuItem -Key $QuitAction1Key -Quit ; $QuitAction1.RuntimeKey = $QuitAction1Key

        #if ($this.Index -gt 0 -or $this.CurrentActionBoard -ne $null)  {$CurrentItem.Menu.ActionItems+= $QuitAction}
        #if ($this.Index -lt $this.Items.Count -1 -and $this.CurrentActionBoard -eq $null) {$CurrentItem.Menu.ActionItems+= $QuitAction1}
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

    $OutTitle = "{0} $($This.Title) — $($CurrentItem.Title) {2} {1}" -f $Arrow1,$Arrow2,$Arrow3
    Write-Host $OutTitle  -ForegroundColor Cyan
    $Arguments = @{} 
    $CurrentPage = $CurrentItem.Pages[$CurrentItem.Index]
    if ($CurrentItem.ArgumentList -ne $null) {
        $Arguments.Add('ArgumentList',$CurrentItem.ArgumentList[$CurrentItem.Index])
    }
   
    try {
        Write-host ($this | Invoke-CommandPiped @Arguments   -ScriptBlock ([scriptblock]::Create($CurrentItem.Pages[$CurrentItem.Index])) | Out-String)
   }
   catch {
       Write-Error $_ -ErrorAction Continue
   }

    if (![Console]::IsInputRedirected) {
        while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}
    }
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
    elseif ($this.Index -eq 0)  {
        $this.Index = $this.Items.Count-1
        $this.Items[$this.Index].Index = 0
        $this.Print()
    }
}

   #Test

    [Void]NextBoard() {
        if ($this.CurrentActionBoard -eq $null) {

            if ($this.Index -lt $this.Items.Count -1)  {
                $this.Index +=1
                $this.Items[$this.Index].Index = 0
                $this.Print()
            } elseif ($this.Index -eq $this.Items.Count -1) {
                $this.Index = 0
                $this.Items[$this.Index].Index = 0
                $this.Print()
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
