Import-Module umd_ModuleParms -Force

Invoke-UdfAddNumber 1 2       		# Returns 3

Invoke-UdfSubtractNumber 5 1		# Returns 4

Invoke-UdfMultiplyNumber 5 6		# Generates an error because the function is not loaded.

Get-Module umd_ModuleParms    		# Confirms that the new function is not loaded.
