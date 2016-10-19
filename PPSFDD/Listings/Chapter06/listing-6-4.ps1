$option = Read-Host "Enter 'A' to Allow underscore or 'D' to disallow the underscore "

if ($option -ne 'A') {
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
}
else
{
$scrblock = 
{
function Get_UdfLetters([string]$p_instring)
  {
     Return ($p_instring -replace '[^A-Z _]','')
  }

function Get_UdfNumbers([string]$p_instring)
  {
     Return ($p_instring -replace '[^0-9_]','')
  }
 }
}

$mod = new-module -scriptblock $scrblock -AsCustomObject

$mod.Get_UdfLetters("mix of numbers-_ 12499 and_ letters")

$mod.Get_UdfNumbers("mix of numbers-_ 12499 and_ letters")
