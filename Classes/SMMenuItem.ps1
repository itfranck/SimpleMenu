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


