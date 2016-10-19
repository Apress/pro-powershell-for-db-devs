$MsgBox = {param([string] $message, [string] $title, [string] $type)  $OFS=','; [System.Windows.Forms.MessageBox]::Show($message , $title,  $type) }

Invoke-Command $MsgBox -ArgumentList "First Message", "Title", "1"

Invoke-Command $MsgBox -ArgumentList "Second Message", "Title", "1"

Invoke-Command $MsgBox -ArgumentList "Third Message", "Title", "1"
