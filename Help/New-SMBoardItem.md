---
external help file: SimpleMenu-help.xml
Module Name: SimpleMenu
online version:
schema: 2.0.0
---

# New-SMBoardItem

## SYNOPSIS
Create a new SmBoardItem.

## SYNTAX

```
New-SMBoardItem [[-Title] <String>] [-Pages <ScriptBlock[]>] [-key <ConsoleKey>] [-Menu <SMMenu>] [-Quit]
 [-ArgumentList <Object[]>] [<CommonParameters>]
```

## DESCRIPTION
Create a new SMBoardItem. Items can have multiple pages and navigation is automatically handled by the SMBoard hosting them.

## EXAMPLES

### Example 1
```powershell
PS C:\> 'Main board'                               | New-SMBoardItem -Pages {'Lorem Ipsum'},{'Content of a second page here'},{Display-CustomPage}
```

This example create a new SMBoardItem that contains 3 pages. Pages scriptblock should display informations otherwise the console screen will be empty. 

## PARAMETERS

### -ArgumentList
{{Fill ArgumentList Description}}

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Menu
Invoke a SMMenu into the board. Useful to add an option page to the board and to suit other needs.

```yaml
Type: SMMenu
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pages
Scriptblock producing a number of informations (string) to be displayed. As soon as multiple pages are used, an up/down arrow will be shown.

```yaml
Type: ScriptBlock[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quit
Item is used to exit the SMBoard. This will exit the module script. Makes most sense used to define an exit key in the ActionItems

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

### -Title
Title of the board item. It will be displayed when navigated to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -key
Key to trigger that item. If the SMBoardItem is a regular item, it will be available with the navigation keys but the key parameter could allows to return to it using that method too. Otherwise, it is mostly intended for the Action Items, which are unavailable otherwise.

```yaml
Type: ConsoleKey
Parameter Sets: (All)
Aliases:
Accepted values: Backspace, Tab, Clear, Enter, Pause, Escape, Spacebar, PageUp, PageDown, End, Home, LeftArrow, UpArrow, RightArrow, DownArrow, Select, Print, Execute, PrintScreen, Insert, Delete, Help, D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, LeftWindows, RightWindows, Applications, Sleep, NumPad0, NumPad1, NumPad2, NumPad3, NumPad4, NumPad5, NumPad6, NumPad7, NumPad8, NumPad9, Multiply, Add, Separator, Subtract, Decimal, Divide, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, F21, F22, F23, F24, BrowserBack, BrowserForward, BrowserRefresh, BrowserStop, BrowserSearch, BrowserFavorites, BrowserHome, VolumeMute, VolumeDown, VolumeUp, MediaNext, MediaPrevious, MediaStop, MediaPlay, LaunchMail, LaunchMediaSelect, LaunchApp1, LaunchApp2, Oem1, OemPlus, OemComma, OemMinus, OemPeriod, Oem2, Oem3, Oem4, Oem5, Oem6, Oem7, Oem8, Oem102, Process, Packet, Attention, CrSel, ExSel, EraseEndOfFile, Play, Zoom, NoName, Pa1, OemClear

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
