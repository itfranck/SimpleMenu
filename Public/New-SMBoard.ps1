function New-SMBoard {
    [cmdletbinding()]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [System.ConsoleKey[]]$NavigationKeys
    )

    return New-Object -TypeName SMBoard -Property $PSBoundParameters


}

