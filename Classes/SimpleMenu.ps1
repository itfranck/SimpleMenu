class SimpleMenu {
    [System.Collections.Generic.List[PSObject]]$Items
    [String]$Title
    [ConsoleColor]$TitleForeGround = [ConsoleColor]::Cyan
    [SimpleMenu]$Parent = $null

    SimpleMenu() {
        $This.Items = New-Object System.Collections.Generic.List[PSObject]
    }

    [PSObject]GetItem($id) {
        $out = ($this.Items | Where-Object {$_.ID -eq $ID} | Select -First 1)
        return $out
    }

    Print() {
        $TitleParams = @{}
        $TitleParams.Add('ForegroundColor', $this.TitleForeGround)
       
        Write-Host "   $($this.Title)" @TitleParams

        $NumberIndex = 0 
        Foreach ($Item in $this.Items) {
   
            if (-not [String]::IsNullOrWhiteSpace($Item.Key)) {
                $item.runtimeKey = $item.Key
            }
            else {
               $NumberIndex++
               $item.runtimeKey = $NumberIndex
        
            }
            Write-host "$($item.runtimeKey). $($Item.Title)"
        }

    }
}

enum WarningMessages{
    Undefined
    None
    InvalidChoice
    NoActionDefined
}