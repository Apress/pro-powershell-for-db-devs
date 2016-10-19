$PSDefaultParameterValues.Add("*:sqlserver","(local)")
$PSDefaultParameterValues.Add("*:sqldatabase","AdventureWorks") 

function Invoke-UdfSQLQuery
{ 
 [CmdletBinding()]
        param (
              [string] $sqlserver       ,   # SQL Server
              [string] $sqldatabase     ,   # SQL Server Database.
              [string] $sqlquery            # SQL Query
          )

  $conn = new-object System.Data.SqlClient.SqlConnection("Data Source=$sqlserver;Integrated Security=SSPI;Initial Catalog=$sqldatabase");
  
  $command = new-object system.data.sqlclient.sqlcommand($sqlquery,$conn)

  $conn.Open()
  
  $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
  $dataset = New-Object System.Data.DataSet
  $adapter.Fill($dataset) | Out-Null
  
  RETURN $dataset.tables[0] 

  $conn.Close()
} 

Invoke-UdfSQLQuery   -sqlquery 'select top 100 * from person.address' 
