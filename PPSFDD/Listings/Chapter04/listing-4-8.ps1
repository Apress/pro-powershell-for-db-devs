clear-host

Set-Location ($env:HOMEDRIVE + $env:HOMEPATH + "\Documents")
$Error.Clear()
Get-Content "nonfile" -ErrorAction Continue
"Continue: $Error " 

$Error.Clear()
Get-Content "nonfile" -ErrorAction Ignore    # Error message is not set. 
"Ignore: $Error " 

$Error.Clear()
Get-Content "nonfile" -ErrorAction Inquire
"Inquire: $Error " 

$Error.Clear()
Get-Content "nonfile" -ErrorAction SilentlyContinue
"SilentlyContinue: $Error " 

$Error.Clear()
Get-Content "nonfile" -ErrorAction Stop
"Stop: $Error " 

#  Suspend is only available for workflows.  
$Error.Clear()
Get-Content "nonfile" -ErrorAction Suspend
"Suspend: $Error "  
