#  Load the state code array 
function Get-udfStatesFromDatabase
{ 
 [cmdletBinding()]
        param (  
          )

$conn = new-object System.Data.SqlClient.SqlConnection("Data Source=(local);Integrated Security=SSPI;Initial Catalog=AdventureWorks");
$conn.Open()

$command = $conn.CreateCommand()

$command.CommandText = "SELECT cast(StateProvinceCode as varchar(2)) as StateProvinceCode  FROM [AdventureWorks].[Person].[StateProvince] where CountryRegionCode = 'US';"

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $command
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

Return $DataSet.Tables[0]

$conn.Close()
}

$global:statelistglobal = Get-udfStatesFromDatabase #  Loads the state codes into variable $global:statelistglobal
$global:statelistglobal
