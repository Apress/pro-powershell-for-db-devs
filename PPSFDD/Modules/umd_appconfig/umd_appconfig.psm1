$configfile = Join-Path -Path $PSScriptRoot -ChildPath "psappconfig.txt" 
$configdata = Get-Content -Path $configfile | ConvertFrom-StringData 

function Get-UdfConfiguation ([string] $configkey)
{
   Return $configdata.$configkey
}

# Get-UdfConfiguation "EDWServer"