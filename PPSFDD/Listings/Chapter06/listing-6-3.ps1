# Example of a Dynamic Module...

$scrblock = {
function Get_UdfLetters([string]$p_instring)
 {
     Return ($p_instring -replace '[^A-Z ]','')
 }

function Get_UdfNumbers([string]$p_instring)
 {
     Return ($p_instring -replace '[^0-9]','')
 } 

}

$mod = new-module -scriptblock $scrblock -AsCustomObject

$mod | Get-Member

$mod.Get_UdfLetters("mix of numbers 12499 and letters")

$mod.Get_UdfNumbers("mix of numbers 12499 and letters") 