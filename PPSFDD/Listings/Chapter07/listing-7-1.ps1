Import-Module umd_database -Force

[psobject] $myssint = New-Object psobject
New-UdfConnection ([ref]$myssint)

$myssint.ConnectionType = 'ADO'
$myssint.DatabaseType = 'SqlServer'
$myssint.Server = '(local)'
$myssint.DatabaseName = 'AdventureWorks'
$myssint.UseCredential = 'N'
$myssint.SetAuthenticationType('Integrated')
$myssint.AuthenticationType

$myssint.BuildConnectionString
$myssint.Connectionstring
$myssint.RunSQL("SELECT top 20 * FROM [HumanResources].[EmployeeDepartmentHistory]", $true)
$myssint.ConnectionString

#  To see the object's methods and properties...
$myssint|get-member