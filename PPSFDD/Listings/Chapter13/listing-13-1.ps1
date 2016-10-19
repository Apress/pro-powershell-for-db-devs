$password = Get-Content ($HOMEDRIVE + $env:HOMEPATH + "\Documents\credential.txt" ) | `
            Convertto-Securestring -AsPlainText –Force

$credential = New-Object System.Management.Automation.PSCredential ("someuser", $password )

Invoke-Command -ScriptBlock { Get-Culture } -Credential $credential
