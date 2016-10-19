Import-Module umd_workflow  # To get the functions we will use  below

$filelist1 = "logcombined.txt", "logcombined2.txt"
$filelist2 = "logcombined3.txt", "logcombined4.txt"

Search-UdfFile -filepath $filepath -filelist $filelist1 -searchstring "*txt*" `
                 –PSComputerName remote1 –AsJob –JobName ‘remote1search’

Search-UdfFile -filepath $filepath -filelist $filelist2 -searchstring "*txt*" `
                 –PSComputerName remote2 –AsJob –JobName ‘remote2search’
