function Get-ConsoleKeyDisplayText($inputObject) {
    [String]$PrintedKey = "[$inputObject]"
    switch ($inputObject.value__) {
        { $_ -in 48..57 -or $_ -in 65..90 } { $PrintedKey = ([char]$_) ; break }
        37 { $PrintedKey = '˂'; break }
        38 { $PrintedKey = '˄'; break } 
        39 { $PrintedKey = '˃'; break } 
        40 { $PrintedKey = '˅'; break } 
        Default {}
    }


    return $PrintedKey


}