Import-Module umd_database -Force

[psobject] $myconnection = New-Object psobject
New-UdfConnection ([ref]$myconnection)

$myconnection.ConnectionType = 'ADO'
$myconnection.DatabaseType = 'SqlServer'
$myconnection.Server = '(local)'
$myconnection.DatabaseName = 'AdventureWorks'
$myconnection.UseCredential = 'N'

$myconnection.SetAuthenticationType('Integrated')
$myconnection.BuildConnectionString
$empid = 1

$myconnection.RunSQL("exec [HumanResources].[uspListEmployeePersonalInfoPS] $empid", $true)  
