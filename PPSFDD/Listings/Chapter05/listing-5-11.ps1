function Invoke-UdfTestDefaultParameters
{ 
 [cmdletBinding()]
        param (
          [string]    $p_string = 'DefaultString',
          [int]       $p_int    = 99,
          [decimal]   $p_dec    = 999.99,
          [datetime]  $p_date   = (Get-Date),
          [bool]      $p_bool   = $True,
          [array]     $p_array  = @(1,2,3),
          [hashtable] $p_hash   = @{'US' = 'United States'; 'UK' = 'United Kingdom'}
          )
  "String is : $p_string"
  "Int is: $p_int"
  "Decimal is: $p_dec"
  "DateTime is  $p_date"
  "Boolean is: $p_bool"
  "Array is: $p_array"
  "Hashtable is: " 
  $p_hash
   
}
#  Let’s call the function with the statement below.
Invoke-UdfTestDefaultParameters 
