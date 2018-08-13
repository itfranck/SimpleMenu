
function Invoke-CommandPiped {
    [cmdletbinding()]
    Param([Parameter(ValueFromPipeline=$true)]$InputObject,
    [scriptblock]$ScriptBlock)
        Process{
            $ScriptBlock.Invoke($InputObject)
    }
}