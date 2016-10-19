function Invoke-UdfAddValue   
{
[cmdletBinding(SupportsShouldProcess=$false)]
        param (
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "number")] 
            [int]$number1,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "number")]
            [int]$number2,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "string")] 
            [string]$string1,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "string")]
            [string]$string2,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "datetime")] 
            [datetime]$datetime1,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "datetime")]
            [int]$days
            )

   Switch ($PScmdlet.ParameterSetName)
   {
   "number"    { "Added Value = " + ($number1 + $number2)   }
   "string"    { "Added Value = " + $string1 + $string2   }
   "datetime"  { "Added Value = " + $datetime1.AddDays($days)  }
   }
}

Invoke-UdfAddValue 1 2
Invoke-UdfAddValue "one" "two"
Invoke-UdfAddValue (Get-Date)  5
