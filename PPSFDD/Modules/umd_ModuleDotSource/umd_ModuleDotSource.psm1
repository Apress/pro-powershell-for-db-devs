<#

.Author
   Bryan Cafferky
.SYNOPSIS
    A simple module to demonstrate using dot sourcing to load the functions.
.DESCRIPTION
    When this module is imported, the functions are loaded using dot sourcing. 



#>

param ( [switch]$IncludeExtended )

. ($PSScriptRoot + "\ufn_add_numbers.ps1")

. ($PSScriptRoot + "\ufn_subtract_numbers.ps1")

if ($IncludeExtended) 
{
  Write-Host "Adding extended modules."
}


