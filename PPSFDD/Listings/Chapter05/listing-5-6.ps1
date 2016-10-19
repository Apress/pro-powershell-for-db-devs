function Invoke-UdfTestValidationArray
{ 
 [cmdletBinding()]
        param (
        [parameter(mandatory=$true,
                   HelpMessage="Enter a string value.")]
                   [ValidateLength(9,11)]
                   [ValidatePattern("^\d{3}-?\d{2}-?\d{4}$")]  # Pattern for SSN
                   [ValidateCount(1,3)]
              [string[]] $inparm1 
          )


   foreach ($item in $inparm1) {
   write-verbose $item
   }
}

Write-Host "Good parameters..."
Invoke-UdfTestValidationArray @("123445678","999-12-1234") -Verbose  # Passes validation
write-host ""

Write-host "Bad parameters, Invalid format..."
Invoke-UdfTestValidationArray @("1234456789","999-12-123488") -Verbose # Fails validation - first element does not match pattern.
write-host ""

Write-host "Bad parameters, Too many elements in the array..."
Invoke-UdfTestValidationArray @("123445678","999-12-1234","123-22-8888","999121234") -Verbose 
