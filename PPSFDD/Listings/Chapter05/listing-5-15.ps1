function Invoke-UdfTestMandatoryParameters2
{ 
 [cmdletBinding()]
        param (
          [Parameter(Mandatory = $true)] 
          [AllowEmptyString()]
          [string]    $p_string,
          [Parameter(Mandatory = $true)] 
          [int]       $p_int,
          [Parameter(Mandatory = $true)] 
          [bool]      $p_bool,
          [Parameter(Mandatory = $true)] 
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

#  By adding the AllowEmptyString attribute, we get the desired behavior. Let’s try a few calls to test this.

Invoke-UdfTestMandatoryParameters2                    # Will be prompted for parameter values.

Invoke-UdfTestMandatoryParameters2 -p_string ''       # Parameter passes validation.

Invoke-UdfTestMandatoryParameters -p_string $null     # Parameter fails validation.
