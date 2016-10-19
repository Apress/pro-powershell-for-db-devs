Import-module umd_database

[psobject] $myconnection = New-Object psobject
New-UdfConnection([ref]$myconnection)

$myconnection.ConnectionType = 'ADO'
$myconnection.DatabaseType = 'SqlServer'
$myconnection.Server = $global:psappconfig.finance.dbserver
$myconnection.DatabaseName = $global:psappconfig.finance.dbname
$myconnection.UseCredential = 'N'
$myconnection.SetAuthenticationType('Integrated')
$myconnection.BuildConnectionString()
$myconnection.RunSQL("select top 10 * from [Sales].[SalesTerritory]", $true) 
