# Simple module example

function Invoke-UdfMultiplyNumber([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 * $p_int2)
}

# Example Call :  Invoke-UdfMultiplyNumber 5 4
