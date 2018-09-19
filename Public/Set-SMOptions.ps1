function Set-SMOptions {
    [CMDLetBinding()]
    Param(
        $Language = 'en'
    )

    if ($PSBoundParameters.ContainsKey('Language')) {
        Import-LocalizedData -BindingVariable Messages -BaseDirectory "$($ModuleRoot)\lang"  -FileName 'strings' -UICulture $Language
        $Script:Messages = $Messages
    }

} 