function Invoke-UdfFileAction {
[cmdletBinding(SupportsShouldProcess=$true)]
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

"somestuff" > somedata.txt   # Creates a file.
Invoke-UdfFileAction -dodelete 'somedata.txt' -Whatif 

Invoke-UdfFileAction -docopy 'copydata.txt' 'newcopy.txt' -Whatif  