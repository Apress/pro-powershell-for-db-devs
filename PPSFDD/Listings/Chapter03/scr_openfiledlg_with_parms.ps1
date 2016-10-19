Param(
  [string]$initdir,
  [string]$filter
 )

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initdir
 $OpenFileDialog.filter = $filter 
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename 
