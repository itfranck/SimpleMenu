$ScriptFullPath = $MyInvocation.MyCommand.Definition
$ScriptDir = Split-Path -Parent $ScriptFullPath

Import-Module "$ScriptDir\SimpleMenu\SimpleMenu.psm1" -Force



Function InstallService() {
    Write-host 'installing service logic here...'
    Write-Host 'Congratulations, your service was installed' -ForegroundColor Green
}

Function UninstallService() {
    Write-Host 'Uninstalling service... '
    Write-Host 'Done.'
}




$OptionsMenu = New-SimpleMenu  -Title 'Options' -TitleForegroundColor Red  -Items @(
    "Enter Powershell prompt"                   | New-SimpleMenuItem -Action {Write-host 'Type exit to go back to menu';$host.enternestedprompt()} -NoPause
    "Edit this menu"                            | New-SimpleMenuItem -Action {powershell_ise.exe "$ScriptFullPath"}
    "Display script full path"                  | New-SimpleMenuItem  -Action {Write-Host $ScriptFullPath -ForegroundColor Yellow}
    "Back"                                      | New-SimpleMenuItem -Key b -Quit
)


$Menu = New-SimpleMenu  -Title 'Service manager'   -Items @(
    "Install Service"                           | New-SimpleMenuItem -ID 'Install'  -Action {InstallService} 
    "Uninstall Service"                         | New-SimpleMenuItem -Action {UninstallService}
    "Options"                                   | New-SimpleMenuItem -key 'O' -submenu $OptionsMenu
    "Change title demo"                         | New-SimpleMenuItem -Id 'ChangeTitle'  -Action {$Menu.GetItem('ChangeTitle').Title = 'New title !'} -NoPause
    "Test Error"                                | New-SimpleMenuItem -Key 'd' -Action {Throw 'Unmanaged error'} -NoPause
    "Exit"                                      | New-SimpleMenuItem -Key 'x' -Action {Write-Host 'Farewell, see you next time !' -ForegroundColor Green} -Quit -NoPause
)



Invoke-SimpleMenu -Menu $Menu 




  

