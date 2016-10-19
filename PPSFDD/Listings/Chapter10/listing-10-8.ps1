#  Create new machine level environment variables to point to the database configuration table.
[Environment]::SetEnvironmentVariable("psappconfigdbserver", "(local)", "Machine")

[Environment]::SetEnvironmentVariable("psappconfigdbname","Development", "Machine")

[Environment]::SetEnvironmentVariable("psappconfigtablename","dbo.PSAppConfig", "Machine")

Get-Process explorer | Stop-Process #  Line to address Windows bug
