$datetime = Get-Date
$answer = "e"

Do
{
   $answer = Read-Host "Enter d for date, t for time or e to exit" 
   if ($answer -eq "t") 
      {
      write-host "The time is " $datetime.ToShortTimeString()
      }
    elseif ($answer -eq "d") 
      {
      write-host "The date is " $datetime.ToShortDateString()
      }
   
}
until ($answer -eq "e") 
