function Invoke-UdfSomething 
{
[CmdletBinding()]
        param (
              [string] $someparm1,
              [string] $someparm2      
               )

   Write-Host "`$someparm1 is $someparm1"
   Write-Host "`$someparm2 is $someparm2"
}

$PSDefaultParameterValues=@{
"Invoke-Udf*:someparm1"="my paramater value";
}

Invoke-UdfSomething 
