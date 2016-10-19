for($i=1; $i -le 2; $i++) {
Get-Process -Id 255 -ErrorAction SilentlyContinue -ErrorVariable hold
"Loop Iteration: $i" 
}
write-host "`r`nError Varibale contains..."
$hold
