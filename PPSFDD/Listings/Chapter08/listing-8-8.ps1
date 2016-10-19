function Invoke-UdfPSCmdlet { 
 [CmdletBinding()]
        param (
          )

    Write-Host "Here is a dump of `$PSCmdLet..."
    $PSCmdlet
  
    Write-Host "Here is a list of the MyInvocaton attributes..."
    $PSCmdlet.MyInvocation

    if($PSCmdlet.ShouldContinue('Click Yes to see GridView of methods and properties...', 'Show GridView'))
    { 
       $PSCmdlet | Get-Member | Out-GridView
    }
  
} 

Invoke-UdfPSCmdlet 
