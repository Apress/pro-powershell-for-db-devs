function Invoke-UdfTestValidationInteger
{ 
 [cmdletBinding()]
        param (
        [parameter(mandatory=$true,
                   HelpMessage="Enter a number between 10 and 999.")]
                   [ValidateRange(10,999)]
                   [ValidateSet(11,12,13, 14, 15)]
              [int] $inparm1 
          )

   write-verbose $inparm1
   
}

Invoke-UdfTestValidationInteger 12 -Verbose     # Good value.

Invoke-UdfTestValidationInteger 17 -Verbose     # Rejected - Within the range but not in the set.

Invoke-UdfTestValidationInteger 9999 -Verbose   # Value too large.

Invoke-UdfTestValidationInteger 11.25 -Verbose  # Accepts the value but truncates it. 
