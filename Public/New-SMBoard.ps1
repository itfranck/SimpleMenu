function New-SMBoard {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/New-SMBoard.md')]
    param( 
        $Title,
        [SMBoardItem[]] $Items,
        [SMBoardItem[]]$ActionItems,
        [INT]$DefaultIndex,
        [Switch]$UseTabs
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
        $Board.PreviousPageKey = [System.ConsoleKey]([int][char]'W')
        $Board.NextPageKey = [System.ConsoleKey]([int][char]'S')
    }
    return $Board


}

