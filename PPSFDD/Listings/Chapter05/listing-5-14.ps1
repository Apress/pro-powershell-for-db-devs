function Invoke-UdfTestMandatoryParameter
{ 
 [cmdletBinding()]
        param (
          [Parameter(Mandatory = $true)] 
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

Invoke-UdfTestMandatoryParameter -p_string '' 

Invoke-UdfTestMandatoryParameter -p_string $null 
