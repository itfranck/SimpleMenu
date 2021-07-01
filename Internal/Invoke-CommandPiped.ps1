
function Invoke-CommandPiped {
    [cmdletbinding()]
    Param([Parameter(ValueFromPipeline = $true)]$InputObject,
        [scriptblock]$ScriptBlock,
        [Object[]]$ArgumentList)
    Process {
        $ScriptBlock.Invoke($ArgumentList)
    }
}