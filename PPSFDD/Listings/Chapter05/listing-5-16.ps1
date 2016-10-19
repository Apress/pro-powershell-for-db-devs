function Invoke-UdfTestMandatoryParameters2
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
#  Now let’s test the function passing a null for $p_int. 
Invoke-UdfTestMandatoryParameters2 -p_string '' -p_int $null

# As expected, the null value is rejected.  Now let’s try passing a zero into $p_int.

Invoke-UdfTestMandatoryParameters2 -p_string '' -p_int 0 
#  The zero value is accepted so we are prompted for $p_bool.  Just press Control+Break to exit the prompt.
