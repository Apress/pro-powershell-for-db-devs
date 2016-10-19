# Simple module example
$somevar = 'Default Value'

function Invoke-UdfAddNumber([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 + $p_int2)
}

function Invoke-UdfSubtractNumber([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 - $p_int2)
}

$mInfo = $MyInvocation.MyCommand.ScriptBlock.Module

$mInfo.OnRemove = {
   Write-Host "Remove Modules"
   }

Export-ModuleMember -Function Invoke-UdfAddNumber -Variable somevar

# Example Function Calls...
#
#  Invoke-UdfAddNumber 1 4 
#  Invoke-UdfSubtractNumber 4 1 