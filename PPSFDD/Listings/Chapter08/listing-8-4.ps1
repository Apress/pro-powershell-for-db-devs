function Invoke-UdfMyFunction ([string]$parm1, [int]$parm2, $parm3 )
{

   $MyInvocation
 
#  Do some work...
}

Invoke-UdfMyFunction "test" 1 "something"
