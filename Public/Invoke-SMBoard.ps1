function Invoke-SMBoard {
    [cmdletbinding()]

    Param(
        [ValidateNotNull()][SMBoard]$Board
    )
$Board.Index =  $Board.DefaultIndex
$PageIndex = 0
$Board.Print()

while ([Console]::KeyAvailable) {[console]::ReadKey($false) | Out-Null}

    while ($true) {
         [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            Switch ($LineRaw.Key) {
               ($Board.Previous) {
                if ($Board.CurrentActionBoard.Quit) {Return}
                        
                $Board.PreviousBoard();break}
               ($Board.Next) {$Board.NextBoard();break}
               ([System.ConsoleKey]::UpArrow) {$Board.PreviousPage();break}
               ([System.ConsoleKey]::DownArrow){$Board.NextPage();break}
               ([System.ConsoleKey]::Escape) {return}
               Default {
                if ($Board.CurrentActionBoard.Quit) {break}
                 $Board.CurrentActionBoard = $Board.ActionItems | where Key -eq $LineRaw.Key
                 if ($Board.CurrentActionBoard -ne $null ) {
                    
                    $Board.Print()
                     break
                 }
               }
            }
    }


}