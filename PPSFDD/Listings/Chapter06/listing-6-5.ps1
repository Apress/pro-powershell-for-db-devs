Import-Module WASP    # Use Import-Module starting with PowerShell 3.0

$url = "http://www.bing.com"

stop-process -processname iexplore*

$ie = New-Object -comobject InternetExplorer.Application 
$ie.visible = $true 
$ie.silent = $true 
$ie.Navigate( $url )

start-sleep 2

Select-Window "iexplore" | Set-WindowActive  

$txtArea=$ie.Document.getElementById("sb_form_q") 
$txtArea.InnerText="PowerShell WASP Examples" 
start-sleep 2

Select-Window "iexplore" | Set-WindowActive| Send-Keys "{ENTER}" 
