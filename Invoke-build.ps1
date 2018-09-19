$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
Import-Module InvokeBuild
Import-Module platyPS
Invoke-Build -File .\SimpleMenu.build.ps1