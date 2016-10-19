<#

.Author
   Bryan Cafferky
.SYNOPSIS
    A simple module that uses dot sourcing to load the functions.
.DESCRIPTION
    When this module is imported, the functions are loaded using dot sourcing. 

#>

#  Get the path to the function files...
$functionpath = $PSScriptRoot + "\function\"

# Get a list of all the function file names...
$functionlist = Get-ChildItem -Path $functionpath -Name 

#  Loop over alll the files and dot source them into memory..
foreach ($function in $functionlist) 
{
    . ($functionpath + $function) 
}
