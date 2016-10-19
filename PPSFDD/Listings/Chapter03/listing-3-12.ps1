$conn = new-Object System.Data.SqlClient.SqlConnection("Server=(local);DataBase=AdventureWorks;Integrated Security=SSPI")
$conn.Open()  | out-null

$cmd = new-Object System.Data.SqlClient.SqlCommand("select top 10 FirstName, LastName from Person.Person", $conn)

$rdr = $cmd.ExecuteReader()

While($rdr.Read()){
    Write-Host "Name: " $rdr['FirstName'] $rdr['LastName']
}

$conn.Close()
$rdr.Close()
 
