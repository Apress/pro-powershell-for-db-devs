[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string]$initdir,
	
   [Parameter(Mandatory=$True,Position=2)]
   [string]$filter 
)
"VerbosePreference is $VerbosePreference"  
 "DebugPreference is $DebugPreference" 

 Write-Verbose "The initial directory is: $initdir" 
 Write-Debug   "The filter is:  $filter"

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initdir
 $OpenFileDialog.filter = $filter 
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename 
