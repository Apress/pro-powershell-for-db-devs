function Invoke-UdfTestMandatoryParameters3
{ 
 [cmdletBinding()]
        param (
          [Parameter(Mandatory = $true)] 
          [AllowEmptyString()]
          [string]    $p_string,
          [Parameter(Mandatory = $true)] 
          [ValidateNotNull()]
          [System.Nullable[int]]  $p_int,
          [Parameter(Mandatory = $true)] 
          [ValidateNotNull()]
          [bool]      $p_bool,
          [Parameter(Mandatory = $true)] 
          [AllowEmptyCollection()]
          [array]     $p_array,
          [Parameter(Mandatory = $true)] 
          [hashtable] $p_hash
          )
  "String is : $p_string"
  "Int is: $p_int"
  "Boolean is: $p_bool"
  "Array is: $p_array"
  Write-Host "Hashtable is: " 
  $p_hash
}
 
# Let’s test the above function with the statements below.
Invoke-UdfTestMandatoryParameters3 -p_string '' -p_int 0 -p_bool $false -p_array $null

# The above statement will cause PowerShell to reject the $p_array parameter.  
# Let’s try the call with an empty array as shown below.
Invoke-UdfTestMandatoryParameters3 -p_string '' -p_int 0 -p_bool $false -p_array @()
