<#  Data specific functions that are part of the Northwind ETL #>

Import-Module umd_database
Import-Module umd_etl_functions
Import-Module umd_join_object

function Invoke-UdfStateSalesTaxLoad
{

#  State Code List #>
$global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"

$salestax = Import-CSV ($global:referencepath + "StateSalesTaxRates.csv")

<#  Define the mapping... #>
$mappingset = @()  # Create a collection object.
$mappingset += (Add-UdfMapping "StateCode" "StateProvinceCD" "'" $true)
$mappingset += (Add-UdfMapping "SalesTaxRate" "StateProvinceSalesTaxRate" "" $false) 

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

}

function  Invoke-UdfProductsTransformation 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$mypipe = "default"                 
               )
    process 
    {  
        if ($mypipe."Minimum Reorder Quantity" -eq [DBNull]::Value) { $mypipe."Minimum Reorder Quantity" = 0 }

       Return $mypipe
    }            
} 

function Invoke-UdfProductLoad
{

<#  Define the mapping... #>
$mappingset = @()  # Create a collection object.
$mappingset += (Add-UdfMapping "[Supplier IDs]" "SupplierIDs" "'" $false)
$mappingset += (Add-UdfMapping "[ID]" "ID" "" $true)
$mappingset += (Add-UdfMapping "[Product Code]" "ProductCode" "'" $false)
$mappingset += (Add-UdfMapping "[Product Name]" "ProductName" "'" $false)
$mappingset += (Add-UdfMapping "[Description]" "Description" "'" $false)
$mappingset += (Add-UdfMapping "[Standard Cost]" "StandardCost" "" $false)
$mappingset += (Add-UdfMapping "[Reorder Level]" "ReorderLevel" "" $false)
$mappingset += (Add-UdfMapping "[Target Level]" "TargetLevel" "" $false)
$mappingset += (Add-UdfMapping "[List Price]" "ListPrice" "" $false)
$mappingset += (Add-UdfMapping "[Quantity Per Unit]" "QuantityPerUnit" "'" $false)
$mappingset += (Add-UdfMapping "[Discontinued]" "Discontinued" "'" $false)
$mappingset += (Add-UdfMapping "[Minimum Reorder Quantity]" "MinimumReorderQuantity" "" $false)
$mappingset += (Add-UdfMapping "[Category]" "Category" "'" $false)
$mappingset += (Add-UdfMapping "[Attachments]" "Attachments" "'" $false)   

$global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"

<# Create the Access database connection object #>
[psobject] $access1 = New-Object psobject
New-UdfConnection ([ref]$access1)
$access1.ConnectionType = 'ODBC'
$access1.DatabaseType = 'Access'
$access1.DatabaseName = ($global:referencepath + 'DesktopNorthwind2007.accdb')
$access1.UseCredential = 'N'
$access1.SetAuthenticationType('DSNLess')
$access1.Driver = "Microsoft Access Driver (*.mdb, *.accdb)"
$access1.BuildConnectionString()

<# Create the SQL Server connection object #>
[psobject] $SqlServer1 = New-Object psobject
New-UdfConnection ([ref]$SqlServer1) 

$SqlServer1.ConnectionType = 'ADO'
$SqlServer1.DatabaseType = 'SqlServer'
$SqlServer1.Server = '(local)'
$SqlServer1.DatabaseName = 'Development'
$SqlServer1.UseCredential = 'N'
$SqlServer1.SetAuthenticationType('Integrated')
$SqlServer1.BuildConnectionString()

$access1.RunSQL("select * from Products order by id", $true) | Invoke-UdfProductsTransformation   `
| Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Merge" -Destinationtablename "[dbo].Products" -connection $SqlServer1 –Verbose

}

function Invoke-UdfOrdersTransformation 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$pipein = "default",
                 [Parameter(ValueFromPipeline=$false)]$filepath                 
               )
    process 
    {  

      $statetaxcsv = Import-CSV ("$filepath" + "StateSalesTaxRates.csv" )
      [hashtable] $statetaxht = @{}
      foreach ($item in $statetaxcsv) {$statetaxht.Add($item.StateCode, $item.SalesTaxRate) } 
       
      [psobject] $pipeout = New-Object psobject

      $pipeout | Add-Member -MemberType NoteProperty -Name "Employee_ID"    `
                            -Value $pipein.Employee_x0020_ID 
      $pipeout | Add-Member -MemberType NoteProperty -Name "Order_Date"     `
                            -Value $pipein.Order_x0020_Date   
      $pipeout | Add-Member -MemberType NoteProperty -Name "Ship_City"      `
                            -Value $pipein.Ship_x0020_City
      $pipeout | Add-Member -MemberType NoteProperty -Name "Ship_State"     `
                            -Value $pipein.Ship_x0020_State_x0020_Province 
      $pipeout | Add-Member -MemberType NoteProperty -Name "Status_ID"      `
                            -Value $pipein.Status_x0020_ID 
      $pipeout | Add-Member -MemberType NoteProperty -Name "Order_ID"       `
                            -Value $pipein.Order_x0020_ID 
      $pipeout | Add-Member -MemberType NoteProperty -Name "Customer_ID"    `
                            -Value $pipein.Customer_x0020_ID 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Sales_Tax_Rate" `
                            -Value 0

      $pipeout.Sales_Tax_Rate = $statetaxht[$pipein.Ship_x0020_State_x002F_Province] 
   
      Return $pipeout
    }            
}

function Invoke-UdfOrderLoad 
{
<#  Define the MS Access Connection - Caution:  32 bit ISE only  #>
$global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"

<# Load orders #>
[xml]$orders = Get-Content ("$global:referencepath" + "Orders.XML" )

<#  Define the mapping... #>
$mappingset = @()  # Create a collection object.
$mappingset += (Add-UdfMapping "Order_ID" "Order_ID" "" $true) 
$mappingset += (Add-UdfMapping "Employee_ID" "Employee_ID" "" $false)
$mappingset += (Add-UdfMapping "Order_Date" "Order_Date" "'" $false) 
$mappingset += (Add-UdfMapping "Ship_City" "Ship_City" "'" $false) 
$mappingset += (Add-UdfMapping "Ship_State" "Ship_State" "'" $false) 
$mappingset += (Add-UdfMapping "Status_ID" "Status_ID" "" $false) 
$mappingset += (Add-UdfMapping "Customer_ID" "Customer_ID" "" $false) 
$mappingset += (Add-UdfMapping "Sales_Tax_Rate" "Sales_Tax_Rate" "" $false) 


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

$orders.dataroot.orders | Invoke-UdfOrdersTransformation -filepath $global:referencepath   `
| Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Merge" -Destinationtablename "dbo.Orders" -connection $SqlServer1 -Verbose

}

function Get-UdfMissingEmployee 
{

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

   <# Load the data. #>
   $missing_employees = $SqlServer1.RunSQL("
    select Employee_ID, count(*) as OrderCount 
    from dbo.Orders               o 
    left join [dbo].[Employees]   e
    on (o.Employee_ID = e.ID)
    where e.ID is null
    Group By Employee_ID;", $True) 
  
  Return $missing_employees
}

function Invoke-UdfCustomersTransformation 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$pipein = "default"           
               )
    process 
    {  
   
      [psobject] $pipeout = New-Object psobject
      
      $pipeout | Add-Member -MemberType NoteProperty -Name "Customer_ID"    `
                            -Value $pipein.substring(0,10).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Company_Name"    `
                            -Value $pipein.substring(11,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Last_Name"    `
                            -Value $pipein.substring(61,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "First_Name"    `
                            -Value $pipein.substring(111,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Title"    `
                            -Value $pipein.substring(211,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "City"    `
                            -Value $pipein.substring(873,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "State"    `
                            -Value $pipein.substring(923,50).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Zip"    `
                            -Value $pipein.substring(973,15).trim() 

      $pipeout | Add-Member -MemberType NoteProperty -Name "Country"    `
                            -Value $pipein.substring(988,50).trim()      
      Return $pipeout
     
    }            
}

function Invoke-UdfCustomerLoad 
{
   <#  Define the MS Access Connection - Caution:  32 bit ISE only  #>
   $global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"
   
   #  Load the tables into variables...
   $customer = Get-Content ("$global:referencepath" + "customers.txt" ) | Invoke-UdfCustomersTransformation | `
               Sort-Object -Property State 
   
   $states = Import-CSV ("$global:referencepath" + "state_table.csv" ) | Sort-Object -Property abbreviation 
   
   <#  Define the mapping and include the columns coming from the joined table... #>
   $mappingset = @()  # Create a collection object.
   $mappingset += (Add-UdfMapping "Customer_ID" "Customer_ID" "" $true) 
   $mappingset += (Add-UdfMapping "Company_Name" "Company_Name" "'" $false)
   $mappingset += (Add-UdfMapping "Last_Name" "Last_Name" "'" $false) 
   $mappingset += (Add-UdfMapping "First_Name" "First_Name" "'" $false) 
   $mappingset += (Add-UdfMapping "Title" "Title" "'" $false) 
   $mappingset += (Add-UdfMapping "City" "City" "'" $false) 
   $mappingset += (Add-UdfMapping "State" "State" "'" $false) 
   $mappingset += (Add-UdfMapping "Zip" "Zip" "" $false) 
   $mappingset += (Add-UdfMapping "Country" "Country" "'" $false) 
   $mappingset += (Add-UdfMapping "name" "State_Name" "'" $false) 
   $mappingset += (Add-UdfMapping "census_region_name" "State_Region" "'" $false) 
   
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
   
   <# Load the data. #>
   $SqlServer1.RunSQL("truncate table [dbo].[Customers]", $false) 
   
   Join-Object -Left $customer -Right $states `
               -Where {$args[0].State -eq $args[1].abbreviation} –LeftProperties "*"   `
               –RightProperties "name","census_region_name" -Type AllInLeft            `
   | Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Insert" -Destinationtablename "dbo.Customers" -connection $SqlServer1 -Verbose

}

function Invoke-UdfEmployeeLoad
{

   #  State Code List #>
   $global:referencepath = $env:HomeDrive + $env:HOMEPATH + "\Documents\"
   
   $employee = Import-CSV ($global:referencepath + "employees.txt") 
   
   <#  Define the mapping... #>
   $mappingset = @()  # Create a collection object.
   $mappingset += (Add-UdfMapping "ID" "ID" "" $true)
   $mappingset += (Add-UdfMapping "Company" "Company" "'" $false) 
   $mappingset += (Add-UdfMapping "First Name" "FirstName" "'" $false) 
   $mappingset += (Add-UdfMapping "Last Name" "LastName" "'" $false) 
   $mappingset += (Add-UdfMapping "Email Address" "EmailAddress" "'" $false) 
   $mappingset += (Add-UdfMapping "Business Phone" "Phone" "'" $false) 

   [psobject] $SqlServer1 = New-Object psobject
   New-UdfConnection ([ref]$SqlServer1) 
   
   $SqlServer1.ConnectionType = 'ADO'
   $SqlServer1.DatabaseType = 'SqlServer'
   $SqlServer1.Server = '(local)'
   $SqlServer1.DatabaseName = 'Development'
   $SqlServer1.UseCredential = 'N'
   $SqlServer1.SetAuthenticationType('Integrated')
   $SqlServer1.BuildConnectionString()

   <# Clear the table... #>
   $SqlServer1.RunSQL("truncate table [dbo].[Employees]", $false) 
  
   # Load the table…
   $employee | Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Insert" -Destinationtablename "dbo.Employees" -connection $SqlServer1 –Verbose

}

# Invoke-UdfEmployeeLoad

