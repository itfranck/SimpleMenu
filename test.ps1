import-module "$PSScriptRoot\SimpleMenu.psd1" -Force

cls
Invoke-Build -File '.\SimpleMenu.build.ps1'
 

