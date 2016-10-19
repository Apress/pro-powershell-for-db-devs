# Author:  Bryan Cafferky      Date:  2014-05-10
#  
# Module:   umd_etl.psm1
#
# Purpose:  Provide common ETL functions to help load external files into SQL Server.
#

<#
   Author:  Bryan Cafferky   2014-10-30

   Purpose:  Send Email Message.

   Note:  For Office365 use "smtp.office365.com" 

   Get smptp settings from:
   http://email.about.com/od/Outlook.com/f/What-Are-The-Outlook-com-Smtp-Server-Settings.htm

#>

 #  Validate a value...
function Invoke-UdfColumnValidation  
{ 
 [CmdletBinding()]
        param (     
              [string] $column,       # value to be checked.
              [ValidateSet("minlength","maxlength","zipcode", "phonenumber", "emailaddress", "ssn", "minintvalue", "maxintvalue")] 
              [string] $validation,    # File name pattern to wait for.
              [parameter(Mandatory=$false)]
              [string] $validationvalue 
          )

    [boolean] $result = $false;

    Switch ($validation)
    {

        "minlength"    { $result = ($column.Length -ge [int] $validationvalue); break  }
        "maxlength"    { $result = ($column.Length -le [int] $validationvalue); break  }
        "zipcode"      { $result = $column -match ("^\d{5}(-\d{4})?$")        ; break }
        "phonenumber"  { $result = $column -match ("\d{3}-\d{3}-\d{4}")       ; break }
        "emailaddress" { $result = $column -match ("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$"); break }
        "ssn"          { $result = $column -match ("^\d{3}-?\d{2}-?\d{4}$")       ; break }
        "minintvalue"  { $result = ([int]$column -ge [int] $validationvalue); break } 
        "maxintvalue"  { $result = ([int]$column -le [int] $validationvalue); break }
        
    }

    Write-Verbose "$column $validation $validationvalue"

    Return $result

 }

          
function Add-UdfMapping 
{ 
 [CmdletBinding()]
        param (
              [string]   $incolumn              , # Column from input pipeline.
              [string]   $outcolumn             , # Output column name.
              [string]   $outcolumndelimiter    , # Character to delimit output column.  
              [boolean]  $iskey                   # True = Key column, False = Not key column
          )

    write-verbose $PSCmdlet.ParameterSetName

    $mapping = New-Object System.Object
    $mapping | Add-Member -MemberType NoteProperty -Name "InColumn" -Value "$incolumn"
    $mapping | Add-Member -MemberType NoteProperty -Name "OutColumn" -Value $outcolumn
    $mapping | Add-Member -MemberType NoteProperty -Name "OutColumnDelimiter" -Value "$outcolumndelimiter"
    $mapping | Add-Member -MemberType NoteProperty -Name "IsKey" -Value "$iskey"
  
    RETURN $mapping
    
}

function Get-UdfInColumnList 
{ 
 [CmdletBinding()]
        param (
               [psobject]  $mapping          
              )

   $inlist = ""                            # Just intializing
   foreach ($key in $mapping)
   {
     $inlist += $key.InColumn + ", " 
   }

   $inlist = $inlist.Substring(0,$inlist.Length - 2)
   Return $inlist
    
}
# Get-UdfInColumnList $mappingset
  
function Get-UdfOutColumnList { 
 [CmdletBinding()]
        param (
                 [psobject] $mapping          
          )
   $outlist = ""                            # Just intializing
   foreach ($value in $mapping)
   {
     $outlist += $value.OutColumn + ", " 
   }

   $outlist = $outlist.Substring(0,$outlist.Length - 2)
   Return $outlist

}
# Get-UdfOutColumnList $mappingset
 
function Get-UdfSQLDML { 
 [CmdletBinding()]
        param (
                 [psobject] $mapping,        
                 [parameter(mandatory=$true,
                            HelpMessage="Enter the DML operation.")]
                            [ValidateSet("Insert","Update","Merge", "Delete")]
                 [string]   $dmloperation,
                 [string]   $destinationtablename   
               )
   [string] $sqldml = ""
   Switch ($dmloperation) 
   {
   Insert 
     {
        $sqldml = "insert into $destinationtablename (" + (Get-UdfOutColumnList $mapping) + ") values (`$valuelist);" ; 
        Write-Verbose $sqldml; break
     }

   Merge 
     {
        $key = $mapping | Where-Object { $_.IsKey -eq $true }
        $sourcekey = $key.Incolumn
        $targetkey = $key.OutColumn
        $sourcecollist = (Get-UdfInColumnList $mapping);
        $insertstatement =   "insert (" + (Get-UdfOutColumnList $mapping) + ") values (`$valuelist)";

        $sqldml = "
               Merge into $destinationtablename as Target USING (VALUES ( `$valuelist )) as Source ( $sourcecollist `
         ) ON Target.$targetkey = Source.$sourcekey `
           WHEN MATCHED THEN                        `
                UPDATE SET `$updatestatement 
           WHEN NOT MATCHED BY TARGET THEN $insertstatement;"; break;
     }
   Delete 
     {
        $key = $mapping | Where-Object { $_.IsKey -eq $true }
        $targetkey = $key.OutColumn
        $sqldml = "Delete from $destinationtablename where $targetkey = `$sourcekeyvalue;"; break
     }     
   } 

   Return $sqldml
}

function Invoke-UdfSQLDML 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$mypipe = "default",  
                 [Parameter(ValueFromPipeline=$False,Mandatory=$True,Position=1)]
                 [psobject] $mapping,        
                 [parameter(ValueFromPipeline=$False,mandatory=$true,Position=2,
                            HelpMessage="Enter the DML operation.")]
                            [ValidateSet("Insert","Update","Merge", "Delete")]
                 [string]   $dmloperation,
                 [Parameter(ValueFromPipeline=$False,Mandatory=$True,Position=3)]
                 [string]  $destinationtablename,
                 [string]  $server,
                 [string]  $database
                 
               )

    begin 
    { 
     $sqldml = Get-UdfSQLDML $mapping -dmloperation $dmloperation "$destinationtablename"
     $dbconn = Get-UdfOpenConnection $server $database
     $command = New-Object system.data.sqlclient.Sqlcommand($dbconn)
    }

    process 
    {  
       $values = ""
       $updatestatement = ""

        foreach($map in $mapping)
        {
           $prop = $map.InColumn.Replace("[", "")
           $prop = $prop.Replace("]", "")
           $delimiter = $map.OutColumnDelimiter
           $values = $values + $delimiter + $_.$prop + $delimiter + "," 
           $updatestatement += $map.OutColumn + " = Source." + $map.InColumn + ","
           #  Get the key column value...
           if ($map.IsKey -eq $true) 
           {
                $sourcekeyvalue = $_.$prop
           }
        }

        $updatestatement = $updatestatement.Substring(0,$updatestatement.Length - 1)  # Strip off the last comma.
        $valuelist = $values.Substring(0,$values.Length - 1)  # Strip off the last comma.
        $sqlstatement = $ExecutionContext.InvokeCommand.ExpandString($sqldml)
        $sqlstatement = $sqlstatement.Replace(",,", ",null,")
        Write-Verbose $sqlstatement
        
        # Write to database...
        $command.Connection = $dbconn
        $command.CommandText = $sqlstatement
        $command.ExecuteNonQuery()     
    }
            
    end 
    {
        $dbconn.Close() 
    }

}


function Get-UdfOpenConnection
{ 
 [CmdletBinding()]
        param (
              [string]$server,
              [string]$database
          )

  Write-Verbose "open connecton"
  $conn = New-Object System.Data.SqlClient.SqlConnection("Data Source=$server;Integrated Security=SSPI;Initial Catalog=$database");

  $conn.Open()
  
  Return $conn
 } 



   