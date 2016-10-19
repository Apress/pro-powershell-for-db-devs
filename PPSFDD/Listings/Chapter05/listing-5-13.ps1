function Invoke-UdfTestParameter
{ 
 [cmdletBinding()]
        param (
          [string]    $p_string,
          [int]       $p_int,
          [decimal]   $p_dec,
          [datetime]  $p_date,
          [bool]      $p_bool,
          [array]     $p_array,
          [hashtable] $p_hash
          )

#  Test the string...
   Switch ($p_string)
      {
       $null      { "String is null"  }
       ""         { "String is empty" }
       default    { "String has a value: $p_string" }
      }

    Switch ($p_int)
      {
       $null      { "Int is null"  }
       0          { "Int is zero" }
       default    { "Int has a value: $p_int" }
      }

     Switch ($p_dec)
      {
       $null      { "Decimal is null"  }
       0          { "Decimal is zero" }
       default    { "Decimal has a value: $p_dec" }
      }

     Switch ($p_date)
      {
       $null      { "Date is null"  }
       0          { "Date is zero" }
       default    { "Date has a value: $p_date" }
      }
      
     Switch ($p_bool)
      {
       $null      { "Boolean is null"  }
       $true      { "Boolean is True" }
       $false     { "Boolean is False" }
       default    { "Boolean has a value: $p_bool" }
      }

     Switch ($p_array)
      {
       $null      { "Array is null"  }
       default    { "Array has a value: $p_array" }
      }

      
     Switch ($p_hash)
      {
       $null      { "Hashtable is null"  }
       default    { "Hashtable has a value: $p_hash" }
      }
   
}

Invoke-UdfTestParameter