import-module "$PSScriptRoot\SimpleMenu.psd1" -Force

cls
#Invoke-Build -File '.\SimpleMenu.build.ps1'
 


New-MarkdownHelp -ModuleGuid 'fb728ffb-6ca9-4602-a332-29c73b068352' -MamlFile 'C:\Program Files\WindowsPowerShell\Modules\SimpleMenu\0.1.0.2\SimpleMenu-Help.xml' -OutputFolder "$PSScriptRoot\help" 