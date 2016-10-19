Import-Module umd_database

[psobject] $myconnection = New-Object psobject
New-UdfConnection([ref]$myconnection)
$myconnection | Get-Member

$myconnection.ConnectionType = 'ADO'
$myconnection.DatabaseType = 'SqlServer'
$myconnection.Server = '(local)'
$myconnection.DatabaseName = 'AdventureWorks'
$myconnection.UseCredential = 'N'
$myconnection.UserID = 'bryan'
$myconnection.Password = 'password'

$myconnection.SetAuthenticationType('Integrated')

$myconnection.BuildConnectionString()

$parmset = @()   # Create a collection object.
# Add the parameters we need to use...
$parmset += (Add-UdfParameter "@BusinessEntityID" "Input" "1" "int32" 0)
$parmset += (Add-UdfParameter "@NationalIDNumber" "Input" "295847284" "string" 15)
$parmset += (Add-UdfParameter "@BirthDate" "Input" "1964-02-02" "date" 0)
$parmset += (Add-UdfParameter "@MaritalStatus" "Input" "S" "string" 1)
$parmset += (Add-UdfParameter "@Gender" "Input" "M" "string" 1)
$parmset += (Add-UdfParameter "@JobTitle" "Output" "" "string" 50)
$parmset += (Add-UdfParameter "@HireDate" "Output" "" "date" 0)
$parmset += (Add-UdfParameter "@VacationHours" "Output" "" "int16" 0)

$myconnection.RunStoredProcedure('[HumanResources].[uspUpdateEmployeePersonalInfoPS]', $parmset)
$parmset  # Lists the output parameters 
