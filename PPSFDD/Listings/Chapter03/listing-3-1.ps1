function Invoke-UdfShownOpenFileDialog { 
[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=0)]
   [string]$initdir,
	
   [Parameter(Mandatory=$True,Position=1)]
   [string]$filter,

   [switch]$multifile
)

   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

   $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
   $OpenFileDialog.initialDirectory = $initdir
   $OpenFileDialog.filter = $filter 

   If ($multifile) 
   {
     $OpenFileDialog.Multiselect = $true
   }
 
   $OpenFileDialog.ShowDialog() | Out-Null
   $OpenFileDialog.filename
}

# Example calling the function…
Invoke-UdfShownOpenFileDialog  "C:\" "All files (*.*)| *.*"  -multifile 
