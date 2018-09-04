class SMMenu {
    [System.Collections.Generic.List[PSObject]]$Items
    [String]$Title
    [ConsoleColor]$TitleForeGround = [ConsoleColor]::Cyan
    [SMMenu]$Parent = $null

    SMMenu() {
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
               $item.runtimeKey = [Enum]::Parse([System.ConsoleKey],"D$NumberIndex")
        
            }
            $PrintedKey = "[$($item.runtimeKey)]"
            switch ($item.runtimeKey.value__) {
                {$_ -in 48..57 -or $_ -in 65..90} {$PrintedKey = ([char]$_) ;break}
                37 {$PrintedKey = '◀';break}
                38 {$PrintedKey = '▲';break} 
                39 {$PrintedKey = '▶';break} 
                40 {$PrintedKey = '▼';break} 
            }
     

            Write-host "$PrintedKey. $($Item.Title)"
        }

    }
}

enum WarningMessages{
    Undefined
    None
    InvalidChoice
    NoActionDefined
}
