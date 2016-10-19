function Invoke-UdfFileAction {
[cmdletBinding(SupportsShouldProcess=$true)]
        param (
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "delete")]
            [switch]$dodelete,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "delete")] 
            [string]$filetodelete,
            [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "copy")]
            [switch]$docopy,
            [Parameter(Mandatory = $true,  
                       ValueFromPipelineByPropertyName=$True, ParameterSetName = "copy")] 
            [string[]]$fullname,
            [Parameter(Mandatory = $true,  
                       ValueFromPipelineByPropertyName=$True, ParameterSetName = "copy")] 
            [long[]]$length,
            [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "copy")] 
            [string]$destpath 
            )

Begin
{ 
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
}

Process
{
if ($docopy) 
   {
     try
     {
         foreach ($filename in $fullname) 
         {
         Copy-Item $filename $destpath -ErrorAction Stop
         write-host "File $filename with length of $length copied to $destpath."
         }
     }
     catch
     {
         "Error:  Problem copying file."
     }
   }
}
} 

#  Let's see would happen without actually doing anything.  
"somestuff" > somedata.txt

Invoke-UdfFileAction -dodelete 'somedata.txt' -whatif 

Get-ChildItem *.txt | Invoke-UdfFileAction -docopy 'c:\users\BryanCafferky\hold\' -WhatIf
