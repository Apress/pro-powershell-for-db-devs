Import-Module WASP
Import-Module umd_database

$url = "http://statetable.com/"

get-process -name iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
$ie = New-Object -comobject InternetExplorer.Application 
$ie.visible = $true 
$ie.silent = $true 
$ie.Navigate( $url )

while( $ie.busy){Start-Sleep 1}
Select-Window "iexplore" | Set-WindowActive 

$btn=$ie.Document.getElementById("USA") 
$btn.Click()

while( $ie.busy){Start-Sleep 1}
$btn=$ie.Document.getElementById("major") 
$btn.Click()

while( $ie.busy){Start-Sleep 1}
$btn=$ie.Document.getElementById("true") 
$btn.Click()

while( $ie.busy){Start-Sleep 1}
$btn=$ie.Document.getElementById("current") 
$btn.Click()

while( $ie.busy){Start-Sleep 1}
$btn = $ie.Document.getElementsByTagName('A') | Where-Object {$_.innerText -eq 'Do not include the US Minor Outlying Islands '} 
$btn.Click()

while( $ie.busy){Start-Sleep 1}
$btn=$ie.Document.getElementById("csv") 
$btn.Click()

start-sleep 8
while( $ie.busy){Start-Sleep 1}
Select-Window iexplore | Set-WindowActive | Send-Keys "%S"

Start-Transaction -RollbackPreference TerminatingError

$sourcepath =  $env:HOMEDRIVE + $env:HOMEPATH + "\downloads\state_table.csv"
$targetpath =  $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\state_table.csv"

Copy-Item $sourcepath $targetpath  -UseTransaction

$CheckFile = Import-CSV $targetpath

If ($CheckFile.Count -lt 50) { Write-host "Error"; Undo-Transaction } else { "Transaction Committed" ; Complete-Transaction }
