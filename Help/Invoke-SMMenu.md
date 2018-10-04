---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# Invoke-SMMenu

## SYNOPSIS
Calls menu interface.

## SYNTAX

```
Invoke-SMMenu [[-Menu] <SMMenu>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Calls the menu interface and loops until the menu is exited through items defined with the Quit switch parameter.
The menu will produce warning if undefined keys are pressed or no actions for a specific menu item was defined.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SMMenu -Menu $Menu
```

Invoke a menu created through the New-SMMenu cmdlet. See that cmdlet for a complete example. 

## PARAMETERS

### -Menu
Menu to be invoked.

```yaml
Type: SMMenu
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Print the mene then exit. 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
This function returns nothing.

## NOTES
Read-host will be used in ISE or if the input is redirected.
Otherwise, read key is used to detect pressed key.
The latter does not requires to press enter.

## RELATED LINKS
