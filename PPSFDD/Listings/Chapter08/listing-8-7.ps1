function Invoke-UdfMyFunction ([string]$parm1, [int]$parm2, $parm3 )
{

   $PSBoundParameters
 
#  Do some work...
}

Invoke-UdfMyFunction "test" 1 "something" 

#  Second call - passing $null
# Invoke-UdfMyFunctionWithlogging $null $null $null
