<#

.Author
   Bryan Cafferky
.SYNOPSIS
    A simple module to demonstrate using dot sourcing to load the functions that includes a parameter.
.DESCRIPTION
    When this module is imported, the functions are loaded using dot sourcing. 

#>

param ( [switch]$IncludeExtended )

. ($PSScriptRoot + "\Invoke-UdfAddNumber.ps1")

. ($PSScriptRoot + "\Invoke-UdfSubtractNumber.ps1")

if ($IncludeExtended) 
{
  Write-Host "Adding extended function: $PSScriptRoot\Invoke-UdfMultiplyNumber.ps1"
  . ($PSScriptRoot + "\Invoke-UdfMultiplyNumber.ps1")
}


