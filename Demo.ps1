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



$OptionsMenu = New-SMMenu  -Title 'Options' -TitleForegroundColor Red   -Items @(
   "Enter Powershell prompt"                   | New-SMMenuItem -Action {Write-host 'Type exit to go back to menu';$host.enternestedprompt()} 
   "Edit this menu"                            | New-SMMenuItem -Action {powershell_ise.exe "$ScriptFullPath"}
   "Display script full path"                  | New-SMMenuItem  -Action {Write-Host $ScriptFullPath -ForegroundColor Yellow}
   "Back"                                      | New-SMMenuItem -Key b -Quit
)

#[Console]::InputEncoding =[System.Text.Encoding]::UTF8
#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8



$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
#New-SMMenuItem -Submenu $OptionsMenu -Debug


$Menu = New-SMMenu  -Title 'Service manager' -Items @(
   "Install Service"                           | New-SMMenuItem -ID 'Install'  -Action {InstallService} 
   "Uninstall Service"                         | New-SMMenuItem -Action {UninstallService} 
   'Empty'                                     | New-SMMenuItem 
   "Change this menu"                          | New-SMMenuItem -Id 'ChangeItem' -Action {$_.Title = 'Yay !';cls;$Menu.Print();}
   "Test Error"                                | New-SMMenuItem -Key 'd' -Action {Throw 'Unmanaged error'} 
   "Options"                                   | New-SMMenuItem -key 'O' -submenu $OptionsMenu
   "Exit"                                      | New-SMMenuItem -Key 'x' -Action {Write-Host 'Farewell, see you next time !' -ForegroundColor Green} -Quit 
)


$Board3 = New-SMBoard -Title 'Crypto informations' -Items @(
    'Refresh'                                  | New-SMBoardItem -Pages {' Page 1'},{'Page 2'},{'Page 3'} 
    'Crypto infos'                             | New-SMBoardItem -Pages {'Board 2'}
    'Meh'                                      | New-SMBoardItem -Pages {Invoke-SMMenu -Menu $Menu; $_.PreviousBoard()} 
)




Invoke-SMBoard -Board $Board3
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
#Invoke-SMMenu -Menu $Menu -lang fr




