function Invoke-SMBoard {
    [cmdletbinding()]

    Param(
        [ValidateNotNull()][SMBoard]$Board
    )
$Board.Index =  $Board.DefaultIndex
$PageIndex = 0
$Board.Print()


    while ($true) {
         [System.ConsoleKeyInfo]$LineRaw = [Console]::ReadKey($true)
            Switch ($LineRaw.Key) {
               ($Board.Previous) { $Board.PreviousBoard();break}
               ($Board.Next) {$Board.NextBoard();break}
               ([System.ConsoleKey]::UpArrow) {$Board.PreviousPage();break}
               ([System.ConsoleKey]::DownArrow){$Board.NextPage();break}
               ([System.ConsoleKey]::Escape) {return}
               Default {
                 $Board.CurrentActionBoard = $Board.ActionItems | where Key -eq $LineRaw.Key
                 if ($Board.CurrentActionBoard -ne $null) {
                     $Board.Print()
                     break
                 }
               }
            }
    }


}