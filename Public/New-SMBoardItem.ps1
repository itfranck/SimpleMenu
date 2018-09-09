function New-SMBoardItem {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()] #No value
        [String]$Title,
        [scriptblock[]]$Pages,
        [System.ConsoleKey]$key,
        [SMMenu]$Menu
    )

     $Item = New-Object -TypeName 'SMBoardItem' -Property $PSBoundParameters

    Return $Item
}
