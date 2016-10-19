function Get-UdfConnectionString
{ 
 [CmdletBinding()]
        param (
              [string] $type              ,   # Connection type, ADO, OleDB, ODBC, etc.
              [string] $dbtype            ,   # Database Type; SQL Server, Azure, MySQL.
              [string] $server            ,   # Server instance name
              [string] $authentication    ,   # Authentication method; Integrated, Logon userid/pw or with credential object.
              [string] $databasename      ,   # Database
              [string] $userid            ,   # User Name if using credential
              [string] $password          ,   # password if using credential
              [string] $dsnname           ,   # dsn name for ODBC connection
              [string] $driver                # driver for ODBC DSN Less connection 
              )

  $connstrings = Import-CSV ($PSScriptRoot + "\connectionstrings.txt")
  
  foreach ($item in $connstrings) 
  {
   
   if ($item.Type -eq $type -and $item.Platform -eq $dbtype -and $item.AuthenticationType -eq $authentication) 
      {
        $connstring = $item.ConnectionString
        $connstring = $ExecutionContext.InvokeCommand.ExpandString($connstring)
        Return $connstring
      }
  } 
  
  # If this line is reached, no matching connection string was found.
  Return "Error - Connection string not found!" 

}


# Purpose:  Encrypt credentials like password to a file for later use..
Function Invoke-UdfCommonDialogSaveFile($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files (*.*)| *.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
} 


function Save-UdfEncryptedCredential {
[CmdletBinding()] param ()

   $pw = read-host -Prompt "Enter the password:" -assecurestring 
   
   $pw | convertfrom-securestring | out-file (Invoke-UdfCommonDialogSaveFile  ($env:HOMEDRIVE + $env:HOMEPATH + "\Documents\" ) )

}

function Invoke-UdfADOSQL
{ 
 [CmdletBinding()]
        param (
              [string] $sqlserver              ,   # SQL Server
              [string] $sqldatabase            ,   # SQL Server Database.
              [string] $sqlquery               ,   # SQL Query
              [string] $sqlauthenticationtype  ,   # $true = Use Credentials, $false = Windows Integrated Security
              [string] $sqluser                ,   # User Name if using credential
              $sqlpw                           ,   # password if using credential
              [string] $sqlconnstring          ,   # Connection string
              [boolean]$sqlisselect                # true = select, false = non select statement 
          )
         
  Write-Verbose "Invoke-UdfADOSQL"

  if ($sqlauthenticationtype -eq 'Credential') 
  { 
     $pw =  $sqlpw  
     $pw.MakeReadOnly()

     $SqlCredential = new-object System.Data.SqlClient.SqlCredential($sqluser,  $pw)
     $conn = new-object System.Data.SqlClient.SqlConnection($sqlconnstring, $SqlCredential)
  }
  else 
  {
     $conn = new-object System.Data.SqlClient.SqlConnection($sqlconnstring);
  }

  $conn.Open()
  
  $command = new-object system.data.sqlclient.Sqlcommand($sqlquery,$conn)

  if ($sqlisselect) 
  { 
     
     $adapter = New-Object System.Data.sqlclient.SqlDataAdapter $command
     $dataset = New-Object System.Data.DataSet
     $adapter.Fill($dataset) | Out-Null
     $conn.Close()
     RETURN $dataset.tables[0] 
  }
  Else
  {
     $command.ExecuteNonQuery()
     $conn.Close()
  }
}

function Get-UdfADOConnection
{ 
 [CmdletBinding()]
        param (
              [psobject]$connection
          )

  Write-Verbose "Get-UdfADOConnection"

  if ($connection.UseCredential -eq 'Y') 
  { 
     $pw =  $sqlpw  
     $pw.MakeReadOnly()

     $SqlCredential = new-object System.Data.SqlClient.SqlCredential($connection.UserID, $connection.Password)
     $conn = new-object System.Data.SqlClient.SqlConnection($connection.ConnectionString, $SqlCredential)
  }
  else 
  {
     $conn = new-object System.Data.SqlClient.SqlConnection($connection.ConnectionString);
  }

  $conn.Open()
  
  Return $conn
 } 

function Invoke-UdfODBCSQL { 
 [CmdletBinding()]
        param (
              [string] $odbcserver              ,   # SQL Server
              [string] $odbcdatabase            ,   # SQL Server Database.
              [string] $odbcquery               ,   # SQL Query
              [string] $odbcauthenticationtype  ,   # $true = Use Credentials, $false = Windows Integrated Security
              [string] $odbcuser                ,   # User Name if using credential
              $sqlpw                            ,   # password if using credential
              [string] $odbcconnstring          ,   # Connection string
              [boolean]$odbcisselect            ,   # true = select, false = non select statement 
              [string] $odbcdsnname             ,   # DSN Name
              [string] $odbcdriver                  # ODBC Driver for DSN Less connection
          )

  $conn = New-Object System.Data.Odbc.OdbcConnection($odbcconnstring)
  $conn.open()
  $command = New-Object system.Data.Odbc.OdbcCommand($odbcquery,$conn)

  if ($odbcisselect) 
  { 
     $dataadapter = New-Object system.Data.Odbc.OdbcDataAdapter($command)
     $datatable = New-Object system.Data.datatable
     $dataadapter.fill($datatable) | Out-Null
     $conn.close()
     RETURN $datatable
  }
  Else
  {
     $command.ExecuteNonQuery()
     $conn.Close()
  }
}

function Invoke-UdfODBCStoredProcedure { 
 [CmdletBinding()]
        param (
              [string] $odbcserver              ,   # SQL Server
              [string] $odbcdatabase            ,   # SQL Server Database.
              [string] $odbcquery               ,   # SQL Query
              [string] $odbcauthenticationtype  ,   # $true = Use Credentials, $false = Windows Integrated Security
              [string] $odbcuser                ,   # User Name if using credential
              $sqlpw                            ,   # password if using credential
              [string] $connectionstring        ,   # connection string
                       $parameterset                # ODBC Driver for DSN Less connection
          )
       
  $conn = New-Object System.Data.Odbc.OdbcConnection($connectionstring)
  $conn.open()
  
  $command = New-Object system.Data.Odbc.OdbcCommand($odbcquery,$conn)

  $command.CommandType = [System.Data.CommandType]'StoredProcedure'; 
  
  foreach ($parm in $parameterset) 
  {
      
    $prm = $command.Parameters.Add($parm.Name, [System.Data.Odbc.OdbcType]$parm.Datatype);
    $prm.Size = $parm.Size
    $prm.Value = $parm.Value;
    $prm.Direction = [System.Data.ParameterDirection]$parm.Direction
    
  }

  $command.ExecuteNonQuery()
  
  $conn.Close()

  $outparms = @{}

  foreach ($parm in $parameterset) 
  {
    if ($parm.Direction -eq 'Output')
    {
        $outparms.Add($parm.Name, $command.Parameters[$parm.Name].value)
    }
  }

  RETURN $outparms
  
}
    
function Invoke-UdfSQL     ([string]$p_inconntype,
                            [string]$p_indbtype, 
                            [string]$p_inserver, 
                            [string]$p_indb, 
                            [string]$p_insql, 
                            [string]$p_inauthenticationtype,
                            [string]$p_inuser, 
                                    $p_inpw,      # No type defined so can be securestring or string
                            [string]$p_inconnectionstring,
                            [boolean]$p_inisselect,
                            [string]$p_indsnname,
                            [string]$p_indriver,
                            [boolean]$p_inisprocedure,
                                     $p_inparms)
{  

  If ($p_inconntype -eq "ADO") 
  {
    If ($p_inisprocedure) 
    {
      RETURN Invoke-UdfADOStoredProcedure $p_inserver $p_indb $p_insql $p_inauthenticationtype $p_inuser $p_inpw $p_inconnectionstring $p_inparms
    }
    Else
    {
      $datatab = Invoke-UdfADOSQL $p_inserver $p_indb $p_insql `
                                $p_inauthenticationtype $p_inuser $p_inpw `
                                $p_inconnectionstring $p_inisselect
      Return $datatab
    }

  }
  ElseIf ($p_inconntype -eq "ODBC") 
  {
     If ($p_inisprocedure) 
     {
       RETURN Invoke-UdfODBCStoredProcedure $p_inserver $p_indb $p_insql $p_inauthenticationtype $p_inuser $p_inpw $p_inconnectionstring $p_inparms
     }
     Else
     {
       $datatab = Invoke-UdfODBCSQL $p_inserver $p_indb $p_insql $p_inauthenticationtype $p_inuser $p_inpw $p_inconnectionstring $p_inisselect $p_indsnname $driver
       Return $datatab
     }
  }
  Else
  {
     Throw "Connection Type Not Supported."
  }
 
}


function Add-UdfParameter { 
 [CmdletBinding()]
        param (
              [string] $name                    ,   # Parameter name from stored procedure, i.e. @myparm
              [string] $direction               ,   # Input or Output or InputOutput
              [string] $value                   ,   # parameter value
              [string] $datatype                ,   # db data type, i.e. string, int64, etc.
              [int]    $size                        # length
          )

    $parm = New-Object System.Object
    $parm | Add-Member -MemberType NoteProperty -Name "Name" -Value "$name"
    $parm | Add-Member -MemberType NoteProperty -Name "Direction" -Value "$direction"
    $parm | Add-Member -MemberType NoteProperty -Name "Value" -Value "$value"
    $parm | Add-Member -MemberType NoteProperty -Name "Datatype" -Value "$datatype"
    $parm | Add-Member -MemberType NoteProperty -Name "Size" -Value "$size"

    RETURN $parm
    
}

function Invoke-UdfADOStoredProcedure
{ 
 [CmdletBinding()]
        param (
              [string] $sqlserver              ,   # SQL Server
              [string] $sqldatabase            ,   # SQL Server Database.
              [string] $sqlspname              ,   # SQL Query
              [string] $sqlauthenticationtype  ,   # $true = Use Credentials, $false = Windows Integrated Security
              [string] $sqluser                ,   # User Name if using credential
              $sqlpw                           ,   # password if using credential
              [string] $sqlconnstring          ,   # Connection string
              $parameterset                        # Parameter properties
          )
         
  if ($sqlauthenticationtype -eq 'Credential') 
  { 
     $pw =  $sqlpw  
     $pw.MakeReadOnly()

     $SqlCredential = new-object System.Data.SqlClient.SqlCredential($sqluser,  $pw)
     $conn = new-object System.Data.SqlClient.SqlConnection($sqlconnstring, $SqlCredential)
  }
  else 
  {
     $conn = new-object System.Data.SqlClient.SqlConnection($sqlconnstring);
  }

  $conn.Open()
  
  $command = new-object system.data.sqlclient.Sqlcommand($sqlspname,$conn)

  $command.CommandType = [System.Data.CommandType]'StoredProcedure'; 

  foreach ($parm in $parameterset) 
  {
    if ($parm.Direction -eq 'Input')
    {
         $command.Parameters.AddWithValue($parm.Name, $parm.Value) >> $null; 
    }
    elseif ($parm.Direction -eq "Output" )
    {
        $outparm1 = new-object System.Data.SqlClient.SqlParameter; 
        $outparm1.ParameterName = $parm.Name
        $outparm1.Direction = [System.Data.ParameterDirection]::Output; 
        $outparm1.DbType = [System.Data.DbType]$parm.Datatype; 
        $outparm1.Size = $parm.Size
        $command.Parameters.Add($outparm1) >> $null  
    }
  }

  $command.ExecuteNonQuery()
  $conn.Close()

  $outparms = @{}

  foreach ($parm in $parameterset) 
  {
    if ($parm.Direction -eq 'Output')
    {
        $outparms.Add($parm.Name, $command.Parameters[$parm.Name].value)
    }
  }

  RETURN $outparms
 
}

function New-UdfConnection 
{
 [CmdletBinding()]
        param (
               [ref]$p_connection
              ) 
   # Connection Type...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name ConnectionType `
                           -Value $p_connectiontype

   # Connection Type...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name DatabaseType `
                           -Value $p_type

   # Connection Server...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name Server `
                           -Value $p_server

   # Connection Database...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name DatabaseName `
                           -Value $p_databasename 

   # Security Type...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name UseCredential `
                           -Value 'N' `
                           -Passthru 

   # Security UserID...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name UserID `
                           -Value '' `
                           -Passthru 

   # Security UserID...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name Password `
                           -Value '' `
                           -Passthru

   # DSNName - For ODBC connections...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name DSNName `
                           -Value 'NotAssigned' `
                           -Passthru

   # Driver - For ODBC connections...
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name Driver `
                           -Value 'NotAssigned' `
                           -Passthru

   # ConnectionString. This is generated with the scriptmethod BuildConnectionString.  Other props must be set first.
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name ConnectionString `
                           -Value 'NotAssigned' `
                           -Passthru

   # AuthenticationType. Value must be in AuthenticationTypes.
   $p_connection.value | Add-Member -MemberType noteproperty `
                           -Name AuthenticationType `
                           -Value 'NotAssigned' `
                           -Passthru

   $p_authentiationtypes = ('Integrated','Logon','Credential', 'StoredCredential', 'DSN', 'DSNLess') 

   $p_connection.value | Add-Member -MemberType noteproperty `
                            -Name AuthenticationTypes `
                            -Value $p_authentiationtypes `
                            -Passthru

 $bauth = @'
    param([string]$p_authentication)

    if ($this.AuthenticationTypes -contains $p_authentication) 
    { 
       $this.AuthenticationType = $p_authentication
    }
    Else
    {
       Throw "Error - Invalid Authentication Type, valid values are " + $this.AuthenticationTypes
    }
           
    RETURN $this.AuthenticationType

'@

    $sauth = [scriptblock]::create($bauth)

    $p_connection.value | Add-Member -MemberType scriptmethod `
                            -Name SetAuthenticationType `
                            -Value $sauth `
                            -Passthru

 $bbuildconnstring = @'
    param()

    If ($this.AuthenticationType -eq 'DSN' -and $this.DSNName -eq 'NotAssigned') { Throw "Error - DSN Authentication requires DSN Name to be set." }

    If ($this.AuthenticationType -eq 'DSNLess' -and $this.Driver -eq 'NotAssigned') { Throw "Error - DSNLess Authentication requires Driver to be set." }

    $Result = Get-UdfConnectionString $this.ConnectionType $this.DatabaseType $this.Server $this.AuthenticationType `
                                        $this.Databasename $this.UserID $this.Password $this.DSNName $this.Driver 

    If (!$Result.startswith("Err"))  { $this.ConnectionString = $Result } Else { $this.ConnectionString = 'NotAssigned' }

'@

    $sbuildconnstring = [scriptblock]::create($bbuildconnstring)

    $p_connection.value | Add-Member -MemberType scriptmethod `
                            -Name BuildConnectionString `
                            -Value $sbuildconnstring `
                            -Passthru

 # Note:  Do NOT put double quotes around the object $this properties as it messes up the values.
 #   **** RunSQL ***
 $bsql = @'
    param([string]$p_insql,[boolean]$IsSelect)

    $this.BuildConnectionString()

    If ($this.ConnectionString -eq 'NotAssigned')  {Throw "Error - Cannot create connection string." }
    
    $Result = Invoke-UdfSQL $this.ConnectionType $this.DatabaseType $this.Server $this.DatabaseName "$p_insql" `
                          $this.AuthenticationType $this.UserID $this.Password $this.ConnectionString $IsSelect `
                          $this.DSNName $this.Driver

    RETURN $Result

'@
    $ssql = [scriptblock]::create($bsql)

    $p_connection.value | Add-Member -MemberType scriptmethod `
                            -Name RunSQL `
                            -Value $ssql `
                            -Passthru  

 # For call, $false is for $IsSelect as this is a store procedure. $true is for IsProcedure
 $bspsql = @'
    param([string]$p_insql, $p_parms)

    $this.BuildConnectionString()

    If ($this.ConnectionString -eq 'NotAssigned')  {Throw "Error - Cannot create connection string." }
    
    $Result = Invoke-UdfSQL $this.ConnectionType $this.DatabaseType $this.Server $this.DatabaseName "$p_insql" `
                          $this.AuthenticationType $this.UserID $this.Password $this.ConnectionString  $false `
                          $this.DSNName $this.Driver $true $p_parms

    RETURN $Result

'@
    $sspsql = [scriptblock]::create($bspsql)

    $p_connection.value | Add-Member -MemberType scriptmethod `
                            -Name RunStoredProcedure `
                            -Value $sspsql `
                            -Passthru  

}


#  Function to provide simple way to run a query to a SQL Server database...
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

<#   Job functions follow... #>

function Show-UdfJobConsole
{
 [CmdletBinding()]
        param (
              [string]$jobnamefilter
          )

    function Show-UdfMessageBox 
    { 
        [CmdletBinding()]
        param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)] 
        [string] $message,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string] $title,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [ValidateRange(0,5)] 
        [int] $type 
        )
      
     RETURN [System.Windows.Forms.MessageBox]::Show($message , $title, $type)
    
    }
          
  $actions = "Show Output", "Stop", "Remove", "Resume", "Clear History"

  while ($true)
  {
  $joblist = Get-Job -Name $jobnamefilter | 
             Out-GridView -Title "PowerShell Job Console" -OutputMode Multiple 

  if ($joblist.count -gt 0) 
  { 
     $selection = $actions | Out-GridView -Title "Select Action" -OutputMode Single 
     foreach ($job in $joblist)
     {
        switch ($selection)  
        {
          "Show Output"
          { 
            $joboutput = Receive-Job -ID $job.ID -Keep -Verbose 4>&1 
            If ($joboutput -eq $null) 
            { 
               Show-UdfMessageBox -message "No output to display" -title 'Error' -type 0
            }
            $joboutput | Out-GridView -Title 'Job Output - Close window to return to the job list' -Wait 
          } 
          "Cancel"
          { 
            $job | Stop-Job
          } 
          "Remove"
          { 
            $job | Remove-Job
          } 
          "Resume"
          { 
            $job | Resume-Job 
          } 
        }
     }
  } 
  else 
  { 
      Break;
  }
 }

} 

<# Example call...
  Show-UdfJobConsole '*'
#>

function Invoke-UdfSQLAgentJob 
{

 [CmdletBinding()]
        param (
                 [string]$sqlserverpath,
                 [string]$jobfilter     = '*'                 
               )
  #  Import the SQL Server module
  if(-not(Get-Module -name "sqlps")) 
  {
     Import-Module "sqlps" -DisableNameChecking
  }

  # Set where you are in SQL Server...
  set-location $sqlserverpath

  while ($true) 
  {

   $jobname = $null

   $jobname = Get-ChildItem |
              Select-Object -Property Name, Description, LastRunDate, LastRunOutcome | 
              Where-Object {$_.name -like "$jobfilter*"} |
              Out-GridView -Title "Select a Job to Run" -OutputMode Single 
   
   If (!$jobname) { Break }

   $jobobject = Get-ChildItem | where-object {$_.name -eq $jobname.Name}
   
   $jobobject.start()
  
  }

}
<#  Example call...
Invoke-UdfSQLAgentJob -sqlserverpath 'SQLSERVER:\SQL\DEFAULT\JobServer\Jobs\'
#>
