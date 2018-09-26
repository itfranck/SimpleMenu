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
