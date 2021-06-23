function Set-SMOptions {
    [cmdletbinding(HelpUri = 'https://github.com/itfranck/SimpleMenu/blob/master/Help/Set-SMOptions.md')]
    Param(
        $Language = 'en'
    )

    if ($PSBoundParameters.ContainsKey('Language')) {
        Import-LocalizedData -BindingVariable Messages -BaseDirectory "$($ModuleRoot)\lang"  -FileName 'strings' -UICulture $Language
        $Script:Messages = $Messages
    }

} 