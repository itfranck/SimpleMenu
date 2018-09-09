function New-SMBoard {
    [cmdletbinding()]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
        [System.ConsoleKey[]]$NavigationKeys,
        [INT]$DefaultIndex
    )

    $ALLKeys = New-Object System.Collections.ArrayList
    if ($ActionItems -ne $null) {
    $ALLKeys.AddRange(@($ActionItems | Select -ExpandProperty key))
}
    $Duplicates = $ALLKeys | Group-Object | where count -gt 1
    if ($Duplicates.Count -gt 0) {
        Write-Error ($Messages.Warning_KeyAlreadyAssigned -f $Duplicates[0].Name)
    }
    


    return New-Object -TypeName SMBoard -Property $PSBoundParameters


}

