Import-Module umd_ModuleParms –Force -ArgumentList $true # Displays message new function loaded. 

Invoke-UdfAddNumber 1 2			# Returns 3

Invoke-UdfSubtractNumber 5 1		# Returns 4

Invoke-UdfMultiplyNumber 5 6 		# Returns 30

Get-Module umd_ModuleParms    		# Confirms that the new function is loaded..
