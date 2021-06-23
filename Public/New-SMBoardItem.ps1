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
