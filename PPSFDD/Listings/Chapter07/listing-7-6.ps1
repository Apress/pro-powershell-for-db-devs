Import-Module umd_database

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection 
$SqlConnection.ConnectionString = "Data Source=(local);Integrated Security=SSPI;Initial Catalog=AdventureWorks"     
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand 
$SqlCmd.CommandText = "[HumanResources].[uspUpdateEmployeePersonalInfoPS]"
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandType = [System.Data.CommandType]'StoredProcedure'
$SqlCmd.Parameters.AddWithValue("@BusinessEntityID", 1) >> $null 
$SqlCmd.Parameters.AddWithValue("@NationalIDNumber", 295847284) >> $null
$SqlCmd.Parameters.AddWithValue("@BirthDate", '1964-02-02') >> $null 
$SqlCmd.Parameters.AddWithValue("@MaritalStatus", 'S') >> $null 
$SqlCmd.Parameters.AddWithValue("@Gender", 'M') >> $null 

#  -- Output Parameters ---
# JobTitle
$outParameter1 = new-object System.Data.SqlClient.SqlParameter 
$outParameter1.ParameterName = "@JobTitle" 
$outParameter1.Direction = [System.Data.ParameterDirection]::Output 
$outParameter1.DbType = [System.Data.DbType]'string' 
$outParameter1.Size = 50
$SqlCmd.Parameters.Add($outParameter1) >> $null 

# HireDate
$outParameter2 = new-object System.Data.SqlClient.SqlParameter 
$outParameter2.ParameterName = "@HireDate" 
$outParameter2.Direction = [System.Data.ParameterDirection]::Output 
$outParameter2.DbType = [System.Data.DbType]'date' 
$SqlCmd.Parameters.Add($outParameter2) >> $null 

# VacationHours
$outParameter3 = new-object System.Data.SqlClient.SqlParameter 
$outParameter3.ParameterName = "@VacationHours" 
$outParameter3.Direction = [System.Data.ParameterDirection]::Output 
$outParameter3.DbType = [System.Data.DbType]'int16' 
$SqlCmd.Parameters.Add($outParameter3) >> $null 

$SqlConnection.Open() 
$result = $SqlCmd.ExecuteNonQuery()
$SqlConnection.Close() 

$SqlCmd.Parameters["@jobtitle"].value
$SqlCmd.Parameters["@hiredate"].value
$SqlCmd.Parameters["@VacationHours"].value
