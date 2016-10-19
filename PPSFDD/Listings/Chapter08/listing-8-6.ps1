function Invoke-UdfMyFunctionWithlogging ([string]$parm1, [int]$parm2 = 3, $parm3 )
{

  "The value of `$parm2 is $parm2"

  if ($parm1) {"Has a value"} else {"No value"}

  if ($parm1 -eq $null) {"No parm passed equals `$null"} else {"No value does not equal `$null"}

  "Let's get the string version of null and try again."
  if ($parm1 -eq [string]$null) {"`$null test worked"} else {"A real value was passed"}


  "Default for `$parm1 is '$parm1'"
  "Default for `$parm2 is $parm2"
  "Default for `$parm3 is $parm3"

  "Notice that `$null equals `$null"
  ($null -eq $null)

  "If we concatenate a $null with other strings, we do not get `$null back"
  $myvar = "Bryan " + $null + "Cafferky"
  $myvar

  [string]$mystr = $null
  "`$null assigned to a string = '$mystr'."
  [int]$myint = $null
  "`$null assigned to a number = $myint."

}

#  Call the function…
Invoke-UdfMyFunctionWithlogging 
