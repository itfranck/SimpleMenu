---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# New-SMMenu

## SYNOPSIS
Create SimpleMenu interface.

## SYNTAX

```
New-SMMenu [[-Title] <String>] [[-Items] <PSObject[]>] [[-ActionItems] <PSObject[]>]
 [[-TitleForegroundColor] <ConsoleColor>] [<CommonParameters>]
```

## DESCRIPTION
Create SimpleMenu Interface and defines menu item.
Submenus should be created prior to their parent menu to allow adding them when creating the latter.

## EXAMPLES

### Complete menu with submenu

```
$OptionsMenu = New-SMMenu  -Title 'Options' -TitleForegroundColor Red  -Items @(
    "Enter Powershell prompt"                   | New-SMMenuItem -Action {Write-host 'Type exit to go back to menu';$host.enternestedprompt()} 
    "Edit this menu"                            | New-SMMenuItem -Action {powershell_ise.exe "$ScriptFullPath"}
    "Display script full path"                  | New-SMMenuItem  -Action {Write-Host $ScriptFullPath -ForegroundColor Yellow}
    "Back"                                      | New-SMMenuItem -Key b -Quit
)


$Menu = New-SMMenu  -Title 'Service manager'   -Items @(
    "Install Service"                           | New-SMMenuItem -ID 'Install'  -Action {InstallService} 
    "Uninstall Service"                         | New-SMMenuItem -Action {UninstallService}
    "Options"                                   | New-SMMenuItem -key 'O' -submenu $OptionsMenu
    "Test Error"                                | New-SMMenuItem -Key 'd' -Action {Throw 'Unmanaged error'} 
    "Exit"                                      | New-SMMenuItem -Key 'x' -Action {Write-Host 'Farewell, see you next time !' -ForegroundColor Green} -Quit 
)

Invoke-SMMenu -Menu $Menu
```

This example create a menu and a submenu.
The submenu is created first, then the main menu.
Special char keys are defined for some options. 
For better readability, each lines of the items array is for a specific menu item, with title being passed as a pipe parameter.
That way, the declaration looks very similar to the actual menu that will be displayed.

## PARAMETERS

### -ActionItems
Array of SimpleMenuItem that should be created using the New-SMMenuItem cmdlet. The action items are just like the normal items but hidden.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
Array of SimpleMenuItem that should be created using the New-SMMenuItem cmdlet.

```yaml
Type: PSObject[]
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
Type: String
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
Position: 3
Default value: Cyan
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SimpleMenu
SimpleMenu class that host all details of created menu.

## NOTES

## RELATED LINKS
