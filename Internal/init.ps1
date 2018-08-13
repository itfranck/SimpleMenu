function init($lang = 'en') {
    Import-LocalizedData -BindingVariable Messages -BaseDirectory 'lang'  -FileName 'strings' -UICulture $lang
    $Script:Messages = $Messages
}
init
