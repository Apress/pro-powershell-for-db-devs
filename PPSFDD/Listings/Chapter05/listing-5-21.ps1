function Invoke-UdfMuliParameterSet   
{
[cmdletBinding()]
        param (
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "set1")] 
            [int]$int1,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "set2")]
            [string]$string2,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "set2")]
            [Parameter(ParameterSetName = "set1")]
            [string]$string3
            )

   Switch ($PScmdlet.ParameterSetName)
   {
   "set1"    { "You called with set1."   }
   "set2"    { "You called with set2."   }
   }
   "You Always pass '$string3' which has a value of $string3."
}

Invoke-UdfMuliParameterSet "one" "two" 
