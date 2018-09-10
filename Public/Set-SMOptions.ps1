function Set-SMOptions {
    [CMDLetBinding()]
    Param(
        $Language = 'en'
    )

    if ($PSBoundParameters.ContainsKey('Language')) {
        Import-LocalizedData -BindingVariable Messages -BaseDirectory 'lang'  -FileName 'strings' -UICulture $Language
        $Script:Messages = $Messages
    }

} 