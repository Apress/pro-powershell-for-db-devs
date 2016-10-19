function Invoke-UdfTestValidationMoney
{ 
 [cmdletBinding()]
        param (
        [parameter(mandatory=$true,
                   HelpMessage="Enter a number with two decimal places.")]
                   [ValidateLength(5,15)]
                   [ValidatePattern("^-?\d*\.\d{2}$")]
              [string] $inparm1 
          )

   write-verbose $inparm1
}

Invoke-UdfTestValidationMoney "123.22" -Verbose  # Good value.

Invoke-UdfTestValidationMoney "1.1" –Verbose  # Not enough digits after the decimal. 

Invoke-UdfTestValidationMoney "12345678912345.25" -Verbose # String is too long.
