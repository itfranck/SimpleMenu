function New-SMBoard {
    [cmdletbinding()]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
        [System.ConsoleKey[]]$NavigationKeys,
        [INT]$DefaultIndex
    )

    return New-Object -TypeName SMBoard -Property $PSBoundParameters


}

