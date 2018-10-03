function New-SMBoard {
    [cmdletbinding()]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
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
    
    $Board = New-Object -TypeName SMBoard -Property $PSBoundParameters
    if ([Console]::IsInputRedirected) {
        $Board.Previous = [System.ConsoleKey]([int][char]'A')
        $Board.Next = [System.ConsoleKey]([int][char]'D')
        $Board.PreviousPage = [System.ConsoleKey]([int][char]'W')
        $Board.NextPage = [System.ConsoleKey]([int][char]'S')
    }
    return $Board


}

