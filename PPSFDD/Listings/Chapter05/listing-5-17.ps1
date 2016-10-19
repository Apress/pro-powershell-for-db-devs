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

# Let’s test the above change with the two statements below.
Invoke-UdfTestMandatoryParameters3 -p_string '' -p_int 0 -p_bool $null     # Rejected

Invoke-UdfTestMandatoryParameters3 -p_string '' -p_int 0 -p_bool $false   # Accepted
