function Invoke-UdfTestValidationNEState
{ 
 [cmdletBinding()]
        param (
        [parameter(mandatory=$true,
                   HelpMessage="Enter a New England state code .")]
                   [ValidateSet("ME","NH","VT", "MA", "RI", "CT")]
              [string] $newenglandstates
          )

   write-verbose $newenglandstates
} 

Invoke-UdfTestValidationNEState "RI" -Verbose   # Passes - RI is in the validation list.

Invoke-UdfTestValidationNEState "NY" -Verbose   # Fails - NY is not in the validation list 
