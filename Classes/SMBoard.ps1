class SMBoard {
    [System.ConsoleKey]$Previous = [System.ConsoleKey]::LeftArrow
    [System.ConsoleKey]$Next = [System.ConsoleKey]::RightArrow
    [psobject[]]$Items
    [String]$Title
    [INT]$Index

        

    [Void]Print() {
    #    ▲△▴▵     ▶▷▸▹ ▼▽▾▿ ◀◁◂◃
    Clear-Host
    $CurrentItem = $this.Items[$this.Index]
    
    $Arrow1 = '◁'
    $Arrow2 = '▷'
    $Arrow3 = ''
    if ($this.Index -gt 0) {$Arrow1 = '◀'}
    if ($this.Index -lt $this.Items.Count -1) {$Arrow2 = '▶'}
    if ($CurrentItem.Pages.Count -gt 1) {
        $Arrow31 = '▼'
        $Arrow32 = '▲'
        
        switch ($CurrentItem.Index) {
            0 {$Arrow32 = '△' }
            {$_ -eq ($CurrentItem.Pages.Count -1)} {$Arrow31 = '▽'}
        }
        $Arrow3 = " ($($Arrow31)$($Arrow32))"
    }

    $OutTitle = "{0} $($This.Title){2} {1}" -f $Arrow1,$Arrow2,$Arrow3
    Write-Host $OutTitle  -ForegroundColor Cyan
    Write-host ($this | Invoke-CommandPiped -ScriptBlock ($CurrentItem.Pages[$CurrentItem.Index]) )

    }

[Void]PreviousBoard() {
    if ($this.Index -gt 0)  {
        $this.Index -=1
        $this.Items[$this.Index].Index = 0
        $this.Print()
    }
}

   

    [Void]NextBoard() {
        if ($this.Index -lt $this.Items.Count -1)  {
            $this.Index +=1
            $this.Items[$this.Index].Index = 0
            $this.Print()
        }
    }

    [Void]PreviousPage() {
        if ($this.Items[$this.Index].PreviousPage()) {
            $this.Print()
        }

    }

    [Void]NextPage() {
        if($this.Items[$this.Index].NextPage()) {
            $this.Print()
        }
    }

}
