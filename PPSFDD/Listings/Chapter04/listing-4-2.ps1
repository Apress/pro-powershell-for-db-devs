Try
{
    Get-Process -Id 255 -ErrorAction Stop
}
Catch [Microsoft.PowerShell.Commands.ProcessCommandException]
{
   write-host "The process id was not found." -ForegroundColor Red
}
Catch 
{
  "Error: $Error" >> errorlog.txt
}
Finally
{
  "Process complete." 
} 
