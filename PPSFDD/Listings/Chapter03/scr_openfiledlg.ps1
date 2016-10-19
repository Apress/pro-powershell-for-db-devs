[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.initialDirectory = $args[0]
$OpenFileDialog.filter = $args[1] 
$OpenFileDialog.ShowDialog() | Out-Null
$OpenFileDialog.filename 
