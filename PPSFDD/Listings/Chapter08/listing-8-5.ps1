function Invoke-UdfMyFunctionWithlogging ([string]$parm1, [int]$parm2, $parm3 )
{

  $logfilepath = $MyInvocation.PSScriptRoot + '\logfile.txt'

  $logline = "function called: " + $MyInvocation.InvocationName + " at " `
             + (Get-Date -format g) + " with parms: " + $MyInvocation.BoundParameters.Keys
  
  $logline  >> $logfilepath

  $logline 

}

Invoke-UdfMyFunctionWithlogging "test" 1 "something" 
