
function Write-UdfMessages
{
  [CmdletBinding()]
  param ()
        
  Write-Host    "This is a regular message."
  Write-Verbose "This is a verbose message."
  Write-Debug   "This is a debug message."

}

Write-UdfMessages
Write-UdfMessages -Verbose
Write-UdfMessages -Debug


