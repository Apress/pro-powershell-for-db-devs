function Invoke-UdfTestManualValidation
{ 
 [cmdletBinding()]
        param (
          [string]    $p_string,
          [System.Nullable[int]]  $p_int,
          [bool]      $p_bool,
          [array]     $p_array,
          [hashtable] $p_hash
          )

  if ($p_string.Length -eq 0) {  Write-Host -foregroundcolor Red 'Specify a string value please.';	return	}

  if ($p_int -le 0) {  Write-Host -foregroundcolor Red 'Specify an integer greater than zero please.';	return	}

  if ($p_array.Count -eq 0 ) {  Write-Host -foregroundcolor Red 'Specify an array with at least one element please.';	return	}

  if ($p_hash.Count -eq 0) {  Write-Host -foregroundcolor Red 'Specify a hashtable with at least one element please.';	return	}

  "String is : $p_string"
  "Int is: $p_int"
  "Boolean is: $p_bool"
  "Array is: $p_array"
  Write-Host "Hashtable is: " 
  $p_hash
} 

Invoke-UdfTestManualValidation -p_string 'x' -p_int 1 -p_array @(1) -p_hash @{"a"="Test"} 

