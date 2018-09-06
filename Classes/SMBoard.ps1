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
    Write-host ($this | Invoke-CommandPiped -ScriptBlock ([scriptblock]::Create($CurrentItem.Pages[$CurrentItem.Index])) )
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
        elseif ($this.Items[$this.Index].PreviousPage()) {
            $this.Print()
        }

    }

    [Void]NextPage() {
        if ($this.CurrentActionBoard -ne $null -and $this.CurrentActionBoard.NextPage()) {
            $this.Print()
        }
        elseif($this.Items[$this.Index].NextPage()) {
            $this.Print()
        }
    }

}
