cls
#  Good flat file blog...
# https://www.simple-talk.com/sysadmin/powershell/powershell-data-basics-file-based-data/

#  Pass Ref with other parameters...
#  http://geekswithblogs.net/Lance/archive/2009/01/14/pass-by-reference-parameters-in-powershell.aspx

ufn_get_sqldml $mappingset -dmloperation Insert "dbo.Products"
ufn_get_sqldml $mappingset -dmloperation Merge "dbo.Products"
ufn_get_sqldml $mappingset -dmloperation Delete "dbo.Products"
   
 # ufn_get_incolumnlist $mapping

Import-Module umd_database

Import-Module umd_etl_functions

function ufn_process_products_transformations 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$mypipe = "default"                 
               )
    process 
    {  
       $mypipe | Add-Member -MemberType NoteProperty -Name "NewName" -Value "Test" 

       if ($mypipe."Minimum Reorder Quantity" -eq [DBNull]::Value) { $mypipe."Minimum Reorder Quantity" = 0 }

       Return $mypipe
    }            
}



<#  Define the mapping... #>
$mappingset = @()  # Create a collection object.
$mappingset += (ufn_add_mapping "[Supplier IDs]" "SupplierIDs" "'" $false)
$mappingset += (ufn_add_mapping "[ID]" "ID" "" $true)
$mappingset += (ufn_add_mapping "[Product Code]" "ProductCode" "'" $false)
$mappingset += (ufn_add_mapping "[Product Name]" "ProductName" "'" $false)
$mappingset += (ufn_add_mapping "[Description]" "Description" "'" $false)
$mappingset += (ufn_add_mapping "[Standard Cost]" "StandardCost" "" $false)
$mappingset += (ufn_add_mapping "[Reorder Level]" "ReorderLevel" "" $false)
$mappingset += (ufn_add_mapping "[Target Level]" "TargetLevel" "" $false)
$mappingset += (ufn_add_mapping "[List Price]" "ListPrice" "" $false)
$mappingset += (ufn_add_mapping "[Quantity Per Unit]" "QuantityPerUnit" "'" $false)
$mappingset += (ufn_add_mapping "[Discontinued]" "Discontinued" "'" $false)
$mappingset += (ufn_add_mapping "[Minimum Reorder Quantity]" "MinimumReorderQuantity" "" $false)
$mappingset += (ufn_add_mapping "[Category]" "Category" "'" $false)
$mappingset += (ufn_add_mapping "[Attachments]" "Attachments" "'" $false) 

$mappingset   


<#  Define the SQL Server Target  #>
Import-Module umd_database

[psobject] $SqlServer1 = New-Object psobject
ufn_create_connection ([ref]$SqlServer1)

$SqlServer1.ConnectionType = 'ADO'
$SqlServer1.DatabaseType = 'SqlServer'
$SqlServer1.Server = '(local)'
$SqlServer1.DatabaseName = 'Development'
$SqlServer1.UseCredential = 'N'
$SqlServer1.SetAuthenticationType('Integrated')

$SqlServer1.BuildConnectionString()
$SqlServer1.ConnectionString

$SqlServer1.RunSQL("select * from [dbo].[Products]", $true) 

<#  Define the MS Access Connection - Caution:  32 bit ISE only  #>
$global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"

[psobject] $access1 = New-Object psobject
ufn_create_connection ([ref]$access1)
$access1.ConnectionType = 'ODBC'
$access1.DatabaseType = 'Access'
$access1.DatabaseName = ($global:referencepath + 'DesktopNorthwind2007.accdb')
$access1.UseCredential = 'N'
$access1.SetAuthenticationType('DSNLess')
$access1.Driver = "Microsoft Access Driver (*.mdb, *.accdb)"
$access1.BuildConnectionString()
$access1.ConnectionString

$access1.RunSQL("select * from Products", $true) 

<#  SQL Server Destination...   #>
[psobject] $SqlServer1 = New-Object psobject
ufn_create_connection ([ref]$SqlServer1)


cls 
# $SqlServer1.RunSQL("truncate table [dbo].Products", $false) ; 
$access1.RunSQL("select * from Products order by id", $true) | ufn_process_products_transformations   `
| ufn_process_sqldml -Mapping $mappingset  -DmlOperation "Merge" -Destinationtablename "[dbo].Products" -connection $SqlServer1 -Verbose

#  Delete...
cls
$access1.RunSQL("select * from Products order by id", $true) | ufn_process_transformations   `
| ufn_process_sqldml -Mapping $mappingset  -DmlOperation "Delete" -Destinationtablename "[dbo].Products" -connection $SqlServer1 -Verbose


$SqlServer1.RunSQL("select * from dbo.Products", $true) | ufn_process_transformations 

cls
$SqlServer1.RunSQL("truncate table dbo.Products", $true)
$myconnection1.RunSQL("select * from Products", $true) | ufn_process_transformations   `
| ufn_process_sqldml -Mapping $mappingset  -DmlOperation "Insert" -Destinationtablename "[dbo].Products" -connection $SqlServer1 -Verbose

#  Load Products...



$myconnection1.RunSQL("select top 10 * from Products", $true) | Select-Object -Property 'Target Level'

$myconnection1.RunSQL("select top 10 * from Products", $true) `
| ufn_process_sqldml -Mapping $mappingset  -DmlOperation "Insert" -Destinationtablename "[dbo].Products" -connection $SqlServer1 -Verbose




