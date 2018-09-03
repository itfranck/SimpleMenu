Function New-Thingy {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true)]$testing
    )
  # Tried playiing with encoding but it didn't do anything.
  #  $Encoding = [System.Text.Encoding]::Default
  #  [Console]::OutputEncoding = $Encoding
  #  [Console]::InputEncoding = $Encoding

      Write-Host $testing
}

"options — test" | New-Thingy
