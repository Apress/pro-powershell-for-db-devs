function Invoke-UdfValidateStateCode ([string] $statecode)
{
   $result = $false
   
   foreach ($states in $global:statelistglobal) 
   {
       if ($states.StateProvinceCode -eq  $statecode) 
       { 
            $result = $true  } 
       }

   Return $result
 }
