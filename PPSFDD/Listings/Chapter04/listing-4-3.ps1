trap { "Error Occurred: $Error." }
Get-Content "nosuchfile" -ErrorAction Stop

"The script continues..."

trap { "Another Error Occurred: $Error."; Break }

Get-Content "nosuchfile" -ErrorAction Stop

"This line will still execute"
