function init($lang = 'en') {
    Import-LocalizedData -BindingVariable Messages -BaseDirectory "$ModuleRoot\lang"  -FileName 'strings' -UICulture $Language
    $Script:Messages = $Messages
}
if ($ModuleRoot -eq $null) { $ModuleRoot = $PSScriptRoot }
init
