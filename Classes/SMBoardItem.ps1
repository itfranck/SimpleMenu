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