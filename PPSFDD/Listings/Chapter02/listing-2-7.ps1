$datetime = Get-Date

$answer = Read-Host "Enter t for time, d for date or b for both"

if ($answer -eq 't') {
   Write-Host "The time is " $datetime.ToShortTimeString()
   }
elseif ($answer -eq "d") {
  Write-Host "The date is " $datetime.ToShortDateString()
   }
else {
  Write-Host "The date and time is $datetime"
}  
