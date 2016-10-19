# Simple module example

$somevar = 'Default Value'

function ufn_add_numbers([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 + $p_int2)
}

function ufn_subtract_numbers([int]$p_int1, [int]$p_int2)
{
     Return ($p_int1 - $p_int2)
}

Export-ModuleMembers ufn_add_numbers, somevar

# Example Function Calls...
#
#  ufn_add_numbers 1 4 
#  ufn_subtract_numbers 4 1 