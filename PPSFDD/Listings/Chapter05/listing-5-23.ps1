function Invoke-UdfFileAction {
[cmdletBinding()]
        param (
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "delete")]
            [switch]$dodelete,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "delete")] 
            [string]$filetodelete,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "copy")]
            [switch]$docopy,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "copy")] 
            [string]$filefrom,
            [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "copy")] 
            [string]$fileto
            )
         
if ($dodelete) 
   {
     try
     {
         Remove-Item $filetodelete -ErrorAction Stop
         write-host "Deleted $filetodelete ."
     }
     catch
     {
         "Error:  Problem deleting old file."
     }
   }

if ($docopy) 
   {
     try
     {
         Copy-Item $filefrom $fileto -ErrorAction Stop
         write-host "File $filefrom copied to $fileto."
     }
     catch
     {
         "Error:  Problem copying file."
     }
   }
}

# The code below shows some examples of calling the function Invoke-UdfFileAction using the different parameter sets.
"somestuff" > somedata.txt

Invoke-UdfFileAction -dodelete 'somedata.txt' 

"somestuff" > copydata.txt
Invoke-UdfFileAction -docopy 'copydata.txt' 'newcopy.txt' 
