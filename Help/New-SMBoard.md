---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# New-SMBoard

## SYNOPSIS
Create a new SMBoard to display informations in an organized method.

## SYNTAX

```
New-SMBoard [[-Title] <Object>] [[-Items] <SMBoardItem[]>] [[-ActionItems] <SMBoardItem[]>]
 [[-DefaultIndex] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Create a new SMBoard to display informations in an organized method.
The SMBoard provides navigation keys for multiple items and allows the creation of a UI providing a convenient way to show informations and also provides interaction through the navigation keys, action items and integrate with SMMenu to allow even more interaction.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Board = New-SMBoard -Title 'Demonstration board' -DefaultIndex 1 -Items @(
    'Options'                   | New-SMBoardItem -Menu $Menu
    'Welcome'                   | New-SMBoardItem -Pages $WelcomePage
    'Config '                   | New-SMBoardItem -Pages {Param($ConfigFile) get-content $ConfigFile } -ArgumentList $TempFileName
    'Some other informations'   | New-SMBoardItem -Pages (Get-Infos)
    'Last item'                 | New-SMBoardItem -Pages {"This is the last page... Here are some infos Lorem Ipsum etc..."}
)
Invoke-SMBoard $Board
```

This example demonstrate ceration of a SMBoard and its invocation.

## PARAMETERS

### -ActionItems
Action Items are not available through the arrow navigation and need to be accessed using the defined key. 

```yaml
Type: SMBoardItem[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultIndex
DefaultIndex can be used to set the initial board item to be displayed not the first one. 

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
Board Items to be dispayed. They can be navigated from and to using navigation keys 

```yaml
Type: SMBoardItem[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Title of the board.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
