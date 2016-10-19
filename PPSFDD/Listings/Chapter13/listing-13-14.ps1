Remove-Module umd_workflow
Import-Module umd_workflow  # To get the functions we will use  below

$filepath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"
$filelist = "logcombined.txt", "logcombined2.txt", "logcombined3.txt", "logcombined4.txt"

Clear-Host  # Just to clear the console.

$starttime = Get-Date
Search-UdwFile -filepath $filepath -filelist $filelist -searchstring "*txt*"
$endtime = get-date
"Execution time: " + ($endtime - $starttime)
