function Invoke-UdfDefaultParameterSet    
{
[cmdletBinding(DefaultParametersetName="set1")]
        param (
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "set1")] 
            [string]$string1,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "set2")]
            [string]$string2
            )

   Switch ($PScmdlet.ParameterSetName)
   {
   "set1"    { "You called with set1."   }
   "set2"    { "You called with set2."   }
   }

}

Invoke-UdfDefaultParameterSet "test"
