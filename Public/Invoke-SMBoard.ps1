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
                ($Board.Previous) { $Board.PreviousBoard()}
               ($Board.Next) {$Board.NextBoard()}
               ([System.ConsoleKey]::UpArrow) {$Board.PreviousPage()}
               ([System.ConsoleKey]::DownArrow){$Board.NextPage()}
               ([System.ConsoleKey]::Escape) {return}
            }
    }


}