Import-Module umd_etl_functions
#  State Code List #>
$global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"

$salestax = Import-CSV ($global:referencepath + "StateSalesTaxRates.csv")

<#  Define the mapping... #>
$mappingset = @()  # Create a collection object.
$mappingset += (Add-UdfMapping "StateCode" "StateProvinceCD" "'" $true)
$mappingset += (Add-UdfMapping "SalesTaxRate" "StateProvinceSalesTaxRate" "" $false) 

Import-Module umd_database

<#  Define the SQL Server Target  #>
[psobject] $SqlServer1 = New-Object psobject
New-UdfConnection ([ref]$SqlServer1) 

$SqlServer1.ConnectionType = 'ADO'
$SqlServer1.DatabaseType = 'SqlServer'
$SqlServer1.Server = '(local)'
$SqlServer1.DatabaseName = 'Development'
$SqlServer1.UseCredential = 'N'
$SqlServer1.SetAuthenticationType('Integrated')
$SqlServer1.BuildConnectionString()

# Load the table…
$SqlServer1.RunSQL("truncate table [dbo].[StateSalesTaxRate]", $false) 
$salestax | Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Insert" -Destinationtablename "dbo.StateSalesTaxRate" -Connection $SqlServer1 -Verbose
