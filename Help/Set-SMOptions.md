---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# Set-SMOptions

## SYNOPSIS
Set SimpleMenu module options. 

## SYNTAX

```
Set-SMOptions [[-Language] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Set SimpleMenu module options. Currently only used to switch language.

## EXAMPLES

### Example 1 - Switch language to french
```powershell
PS C:\> Set-SMOptions -Language fr
```

This example will set the language of the hardcoded elements to french. 

## PARAMETERS

### -Language
Language of the hard coded elements (en/fr)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
