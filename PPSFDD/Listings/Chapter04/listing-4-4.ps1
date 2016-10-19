#  Listing 4-4.  Workaround to replace a trap
[boolean] $stopscript = $false

trap { "Error Occurred: $Error."; If ($stopscript -eq $true) {break}  }
Get-Process 255 -ErrorAction Stop

"The script continues..."
$stopscript = $true

Get-Process 255 -ErrorAction Stop

"This line will NOT execute" 
