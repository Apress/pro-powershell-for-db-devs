function Invoke-UdfTestValidation
{ 
 [cmdletBinding()] 
        param (
        [         parameter(mandatory=$true, HelpMessage="Enter a folder path .")]
                  [ValidateScript({ Test-Path $_ -PathType Container })]
                  [string] $folder, 
                  [parameter(mandatory=$true, HelpMessage="Enter a New England state code.")]
                  [ValidateScript({ Invoke-UdfValidateStateCode $_ })]
                  [string] $statecode 

          )
   write-verbose $statecode  
} 


