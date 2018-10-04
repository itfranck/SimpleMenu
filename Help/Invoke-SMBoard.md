---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# Invoke-SMBoard

## SYNOPSIS
Invoke SMBoard to display informations in a convenient manner.

## SYNTAX

```
Invoke-SMBoard [[-Board] <SMBoard>] [<CommonParameters>]
```

## DESCRIPTION
Invoke SMBoard to display informations in a convenient manner.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SMBoard $Board
```

Invoke a SMBoard created previously through New-SMBoard. See that cmdlet for a full example.

## PARAMETERS

### -Board
SMBoard to be invoked.

```yaml
Type: SMBoard
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
