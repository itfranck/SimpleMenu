# Simple Menu 
Create interactive console applications easily. 
Focus on your actual code and let SimpleMenu handles the UI details for you.

## License 
The Simple Menu project and module are licensed under the [GNU Lesser General Public License](https://www.gnu.org/licenses/lgpl-3.0.en.html).

## Installation

``` 
Install-Module SimpleMenu 
```

## Documentation
[CMDLET Documentation](Help/README.md)

## Components
There are two main components in the SimpleMenu.
The simple menu itself and the simple board. 
The simple menu is just that, a menu that present choices and perform actions. 
The simple board, on the other hand, is a group of panel that can be navigated from left to right and displays
informations. You can have multiple pages to a single panel, which will then be navigated using the up/down arrow keys. 

The simple menu default behavior is to display the result under the menu location but the -Detailed switch can be used to display the result of its action into a single panel that need to be exited using the left arrow. This is particularly useful if you expect the menu action to displays more than a few lines. 

The simple board can also integrate menus within it through the use of the -menu parameter. 

## Notes
Regarding the smboard navigation, arrows (Left/Right Down/Up) are used by default.
However, in ISE, they are replaced by WASD controls.
Furthermore, ISE not supporting the ReadKey method, ENTER must be pressed after each key press to actually process the key. 
VSCode and the Powershell are not affected by this. 


### Example
Here is what the structure of a simple menu looks like.
Relevant parameters are passed down through the New cmdlet while all which is managing the flow of the menu, key bindings, etc is handled for you by the module. 


See the examples folder for more demonstrations.
```

$options = New-SMMenu -Title 'Quick actions' -Items @(
    'Empty all recycle bins'                    | New-SMMenuItem -Title -Action {Write-Host 'Clearing all recycle bins...' -ForegroundColor Cyan;Clear-RecycleBin -Force;Write-Host 'Done!' -ForegroundColor Green}
    'Back'                                      | New-SMMenuItem -Quit -Key B
) -ActionItems @(
    'Back'                                      | New-SMMenuItem -Quit -Key Escape
)


$Menu = New-SMMenu -Title 'Computers infos' -Items @(
    'Computer informations'                     | New-SMMenuItem -Detailed -Action ${function:Get-ComputerInfos}
    'IP Address'                                | New-SMMenuItem -Title -Detailed -Action ${function:Get-BaseInfos}
    'Quick actions'                             | New-SMMenuItem -Submenu $options
    'About'                                     | New-SMMenuItem -Title -Key Z -ForegroundColor Yellow -Action {Param($AboutOut) "$AboutOut"} -Detailed -ArgumentList $AboutOut
    'Quit'                                      | New-SMMenuItem -Title  -Key X -Quit
    
    
) -ActionItems @(
    'Quit'                                      | New-SMMenuItem -Key Escape -Quit
)

Invoke-SMMenu $Menu 
```



