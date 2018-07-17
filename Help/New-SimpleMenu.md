---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# New-SimpleMenu

## SYNOPSIS
Create SimpleMenu interface.

## SYNTAX

```
New-SimpleMenu [[-Title] <Object>] [[-Items] <Object>] [[-TitleForegroundColor] <ConsoleColor>]
 [[-Id] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Create SimpleMenu Interface and defines menu item.
Submenus should be created prior to their parent menu to allow adding them when creating it.

## EXAMPLES

### Complete menu with submenu
@{paragraph=PS C:\\\>}

```
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
```

This example create a menu and a submenu.
The submenu is created first, then the main menu.
Special char keys are defined for some options. 
For better readability, each lines of the items array is for a specific menu item, with title being passed as a pipe parameter.
That way, the declaration looks very similar to the end product.

## PARAMETERS

### -Id
ID of the menu.
Currently unusedé

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
Array of SimpleMenuItem that should be created using the New-SimpleMenuItem cmdlet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Defines menu title.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TitleForegroundColor
Foreground color of the menu title.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 2
Default value: Cyan
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SimpleMenu
SimpleMenu class that host all details of created menu.

## NOTES

## RELATED LINKS
