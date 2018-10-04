Get-module SimpleMenu | Remove-module -Force 
#powershell.exe -File '\..\SimpleMenu.psm1'

Import-Module "$Script:PSScriptRoot\..\SimpleMenu.psm1" -Force


$TempFileName = [System.IO.Path]::GetTempFileName()
Set-Content -Path $TempFileName -Value @"
{
    "Param1":  "Value",
    "Lorem":  "Ipsum"
}
"@

$ModuleInfos = @"
$(Get-module SimpleMenu | fl | Out-String)
"@


Function Get-Infos() {
$Page1 = {
    @"
This is a simple demonstration to show what SimpleMenu is about. 
SimpleMenu objective is to leave you focused on the actual code to deliver while leaving the presentation, 
layout, key handling and other details to the module. 
"@
}

$Page2 = {"See https://github.com/itfranck/SimpleMenu for more informations."}

$Page3 = {"Lorem Ipsum ... "}
return $Page1,$Page2,$Page3
}

$WelcomePage = {
    Write-Host "Welcome to this SMMenu board demonstration." -ForegroundColor Green

    @"
Use Left and right arrows to navigate (substitude by A and S in ISE due to ISE limitations)
When a board item have mutltiple pages, up and down arrows to navigate through them (W & S in ISE)
"@
}


$Menu = New-SMMenu -Title 'Options' -Items @(
    'Edit config'               | New-SMMenuItem -Action {Param($ConfigFile) Start-Process Notepad -ArgumentList $ConfigFile -Verb RunAs} -ArgumentList $TempFileName
    'Module informations'       | New-SMMenuItem -Action {Param($ModuleInfos) Write-Host $ModuleInfos} -ArgumentList $ModuleInfos -Detailed
    'Go to the last board'      | New-SMMenuItem -Id 'LastItem' -Key L -Quit
) -ActionItems @(
    'quit'                      | New-SMMenuItem -Key Escape -Quit
)

$Board = New-SMBoard -Title 'Demonstration board' -DefaultIndex 1 -Items @(
    'Options'                   | New-SMBoardItem -Menu $Menu
    'Welcome'                    | New-SMBoardItem -Pages $WelcomePage
    'Config '                   | New-SMBoardItem -Pages {Param($ConfigFile) get-content $ConfigFile } -ArgumentList $TempFileName
    'Some other informations'   | New-SMBoardItem -Pages (Get-Infos)
    'Last item'                 | New-SMBoardItem -Pages {"This is the last page... Here are some infos Lorem Ipsum etc..."}
)

$Menu.GetItem('LastItem').Action = {Param($Board) $Board.Index = $Board.Items.Count -1;$Board.Print()}
$Menu.GetItem('LastItem').ArgumentList = $Board

$Board.Index = $Board.Items.Count -1

Invoke-SMBoard $Board