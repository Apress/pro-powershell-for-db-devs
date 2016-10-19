function Invoke-UdfShownOpenFileDialog { 
<#     
.SYNOPSIS 
    Opens a Windows Open File Common Dialog.       
.DESCRIPTION 
    Use this function when you need to provide a selection of files to open.
.NOTES 
    Author: Bryan Cafferky, BPC Global Solutions, LLC

.PARAMETER initdir
The directory to be displayed when the dialog opens.

.PARAMETER title
This is the title to be put in the window title bar.

.PARAMETER filter  
The file filter you want applied such as *.csv in the format 'All files (*.*)| *.*' .

.PARAMETER multifile
Switch that is passed enables multiple files to be selected.
  
.LINK 
    Place link here.
.EXAMPLE 
   ufn_show_openfiledialog  "C:\" "All files (*.*)| *.*"  -multifile  
.EXAMPLE   
    ufn_show_openfiledialog  "C:\" "All files (*.*)| *.*"  
#>  

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

get-help  Invoke-UdfShownOpenFileDialog -full
