# Simple module example

function Invoke-UdfAddNumber([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 + $p_int2)
}

# Example Function Calls...
#
#  Invoke-UdfAddNumber 1 4 
