<# Author:  Bryan Cafferky      Date:  2013-11-29
   Purpose:  Speaks the input...
  Fun using SAPI - the text to speech thing....   
#> 

# Variable declarations…
$speaker = new-object -com SAPI.SpVoice  # Since PowerShell defaults variables to objects, no need to declare it.

[string]$saythis = ""    # Note:  If you don't declare the type as string, you won't have the string methods available to you.

[string] $option = "x"

while ($option.toUpper() -ne "S")
{                                                   # --> Open Brace defines the start of a code block.
   $option = read-host "Enter d for read directory, i for say input, s to stop"

   if ($option -eq "d") 
   {
     $saythis = Get-ChildItem
     $saythis = $saythis.substring(1, 50) 
   }
   elseif ($option -eq "i") {
          $saythis = read-host "What would you like me to say?"
        }
   else {
          $saythis = "Stopping the program."
        }

   $speaker.Speak($saythis, 1) | out-null   # We are piping the return value to null, i.e. like void is C#
}                                                # --> Closing Brace defines the end of a code block.
