class SimpleMenuItem {
    [ScriptBlock]$Action = $null
    [System.ConsoleColor]$ForegroundColor
    [String]$Id
    $Key = $null
    [SimpleMenuItem]$Parent = $null
    [Switch]$Pause
    [Switch]$Quit
    [SimpleMenu]$Submenu
    [String]$Title
    $runtimeKey
}


