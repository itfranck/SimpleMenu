$ScriptFullPath = $MyInvocation.MyCommand.Definition
Import-Module '.\SimpleMenu.psm1' -Force

 
Function InstallService() {
   Write-host 'installing service logic here...'
   Write-Host 'Congratulations, your service was installed' -ForegroundColor Green
}

Function UninstallService() {
   Write-Host 'Uninstalling service... '
   Write-Host 'Done.'
   throw 'test error'
}



$OptionsMenu = New-SimpleMenu  -Title 'Options' -TitleForegroundColor Red   -Items @(
   "Enter Powershell prompt"                   | New-SimpleMenuItem -Action {Write-host 'Type exit to go back to menu';$host.enternestedprompt()} 
   "Edit this menu"                            | New-SimpleMenuItem -Action {powershell_ise.exe "$ScriptFullPath"}
   "Display script full path"                  | New-SimpleMenuItem  -Action {Write-Host $ScriptFullPath -ForegroundColor Yellow}
   "Back"                                      | New-SimpleMenuItem -Key b -Quit
)

#[Console]::InputEncoding =[System.Text.Encoding]::UTF8
#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8



$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
#New-SimpleMenuItem -Submenu $OptionsMenu -Debug


$Menu = New-SimpleMenu  -Title 'Service manager' -Items @(
   "Install Service"                           | New-SimpleMenuItem -ID 'Install'  -Action {InstallService} 
   "Uninstall Service"                         | New-SimpleMenuItem -Action {UninstallService} 
   'Empty'                                     | New-SimpleMenuItem 
   "Change this menu"                          | New-SimpleMenuItem -Id 'ChangeItem' -Action {$_.Title = 'Yay !';cls;$Menu.Print();}
   "Test Error"                                | New-SimpleMenuItem -Key 'd' -Action {Throw 'Unmanaged error'} 
   "Options"                                   | New-SimpleMenuItem -key 'O' -submenu $OptionsMenu
   "Exit"                                      | New-SimpleMenuItem -Key 'x' -Action {Write-Host 'Farewell, see you next time !' -ForegroundColor Green} -Quit 
)


$Board3 = New-SMBoard -Title 'Crypto informations' -Items @(
    'Refresh'                                  | New-SMBoardItem -Pages {' Page 1'},{'Page 2'},{'Page 3'} 
    'Crypto infos'                             | New-SMBoardItem -Pages {'Board 2'}
    'Meh'                                      | New-SMBoardItem -Pages {Param($Board3) Invoke-SimpleMenu $Menu;$Board3.PreviousBoard()} 
)




Invoke-SMBoard -Board $Board3
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
#Invoke-SimpleMenu -Menu $Menu -lang fr




