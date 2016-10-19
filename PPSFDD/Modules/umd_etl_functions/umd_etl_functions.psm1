# Author:  Bryan Cafferky      Date:  2014-05-10
#  
# Module:   umd_etl_functions.psm1
#
# Purpose:  Provide common ETL functions to help load external files into SQL Server.

# 
# Purpose:  For loads of FTPed files.  Wait for the file to arrive...
#
#

Import-Module umd_database

#  Load the application configuration settings...
function Set-UdfConfiguration { 
 [CmdletBinding()]
        param (
                [ref]      $config   
              )

    $projects   = Import-CSV -Path $env:psappconfigpath | Select-Object -Property Project |  Get-unique -AsString 
    $configvals = Import-CSV -Path $env:psappconfigpath  

    foreach ($project in $projects) 
    {
        $configlist = @{}

        foreach ($item in $configvals) 
        {
            if ($item.project -eq $project.project )  { $configlist.Add($item.name, $item.value)  }
        }

        #  Add the noteproperty with the configuration hashtable as the value.
        $config.value | Add-Member -MemberType NoteProperty -Name $project.project -Value $configlist 
    }
    
}


function Set-UdfConfigurationFromDatabase 
{ 
 [CmdletBinding()]
        param (
                [string] $sqlserver,
                [string] $sqldb,
                [string] $sqltable   
              )

    [psobject] $config = New-Object psobject

    $projects = Invoke-UdfSQLQuery -sqlserver $sqlserver `
                                  -sqldatabase $sqldb   `
                                  -sqlquery "select distinct project from $sqltable;"

    $configrows = Invoke-UdfSQLQuery -sqlserver $sqlserver -sqldatabase $sqldb `
                                    -sqlquery "select * from $sqltable order by project, name;"
    
    foreach ($project in $projects) 
    {
        $configlist = @{}

        foreach ($configrow in $configrows) 
        {
            if ($configrow.project -eq $project.project )  
                  { $configlist.Add($configrow.name, $configrow.value)  }
        }

        #  Add the noteproperty with the configuration hashtable as the value.
        $config | Add-Member -MemberType NoteProperty -Name $project.project -Value $configlist 
    }
    
     Return $config
}

#  Set-UdfConfigurationFromDatabase '(local)' 'Development' 'dbo.PSAppConfig'


# *** Wait-UdfFileCreation ***

function Wait-UdfFileCreation
{ 
 [CmdletBinding()]
        param (
              [string] $path,   # Folder to be monitored
              [string] $file    # File name pattern to wait for.
          )

   $theFile = $path + $file
 
   #  $theFile variable will contain the path with file name of the file we are waiting for.
   While ($true) {
       Write-Verbose $theFile
       IF (Test-Path $theFile) {
           #file exists. break loop
           break
       }
       #sleep for 2 seconds, then check again - change this to fit your needs...
       Start-Sleep -s 2
}
    Write-Verbose 'File found.'
}

# Example call below...
# Wait-UdfFileCreation ($env:HOMEDRIVE + $env:HOMEPATH + '\Documents\') 'filecheck.txt' -Verbose

#  *** Copy-UdfFile ***

# Purpose:  Copy a file from one folder to another.
#
#

function Copy-UdfFile {
 [CmdletBinding(SupportsShouldProcess=$true)]
        param (
            [string]$sourcepathandfile,
            [string]$targetpathandfile,
            [switch]$overwrite 
          )

   $ErrorActionPreference = "Stop"
   $VerbosePreference = "Continue" 

   Write-Verbose "Source: $sourcepathandfile"
   Write-Verbose "Target: $targetpathandfile"

   try
   {
    If ($overwrite = $true)   {
     Copy-Item -PATH $sourcepathandfile -DESTINATION $targetpathandfile -Force }
    else {
     Copy-Item -PATH $sourcepathandfile -DESTINATION $targetpathandfile }
    }
   catch
   {
      "Error moving file."
   }
}

# Example Call:
#   Copy-UdfFile -Verbose -Overwrite 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\file*.zip' 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\DifferentFolder'     


#  *** Expand-UdfFile ***

#  Purpose:  Decompress files in Zip format.
function Expand-UdfFile 
{
[CmdletBinding(SupportsShouldProcess=$true)]
        param (
            [string]$sourcefile,
            [string]$destinationpath,
            [switch]$force 
          )

    $shell=new-object -com shell.application
    $zipfile = $shell.NameSpace($sourcefile)

    if ($force) {$zipparm = 0x14 }  else { $zipparm = $null }

   foreach ($item in $zipfile.items())
   {
      Try 
      {
         $shell.NameSpace($destinationpath).CopyHere($item, $zipparm) 
      }
      Catch 
      {
         Write-Verbose "File exists already and was overwritten."
      }
   }
}

# Example Call:
#    Expand-UdfFile c:\  d:\ -force

# *** Move-UdfFile ***

# Purpose:  Move a file from one folder to another.

function Move-UdfFile 
{
[CmdletBinding(SupportsShouldProcess=$true)]
        param (
            [string]$sourcepathandfile,
            [string]$targetpathandfile,
            [switch]$overwrite 
          )

      Write-Verbose 'Move file function...'

      try
      {
        If ($overwrite)   
        {
         Move-Item -PATH $sourcepathandfile -DESTINATION $targetpathandfile -Force 
        }
       else 
         {
          Move-Item -PATH $sourcepathandfile -DESTINATION $targetpathandfile 
         }
       }
       catch
       {
         "Error moving file."
         break
       }   
}

function Add-UdfFileNameToFile 
{
[CmdletBinding(SupportsShouldProcess=$true)]
        param (
            [string]$sourcepath,
            [string]$targetpath,
            [string]$filter 
          )

      Write-Verbose "source: $sourcepath"
      Write-Verbose "target: $targetpath"
      Write-Verbose "filter: $filter "
      Write-Verbose $filelist

      $filelist = Get-ChildItem -Path $sourcepath $filter

      foreach ($file in $filelist)
      {
        $csv = get-content $file
        
        $start = 0
     
        $file_wo_comma = $file.name.Replace(',','_')
        $file_wo_comma = $file_wo_comma.Replace(' ','')
     
        $targetpathandfile = $targetpath +  $file_wo_comma    

        Write-Verbose $targetpathandfile
     
        foreach ($line in $csv)
           {
           if ($start -eq 0) 
               {
                 $line += ",filename"
                 $line > $targetpathandfile 
               }
           else
               {
               if ($line -ne '')
                 {
                 $line +=",$file_wo_comma"
                 $line >> $targetpathandfile 
                 }
               }
         
           $start = 1
     
           }   

        }   

}

#  Add-UdfFileNameToFile "test" "test2" "test3"

<#
   Author:  Bryan Cafferky   2014-10-30

   Purpose:  Send Email Message.

   Note:  For Office365 use "smtp.office365.com" 

   Get smptp settings from:
   http://email.about.com/od/Outlook.com/f/What-Are-The-Outlook-com-Smtp-Server-Settings.htm

#>

function Send-UdfMail  
{
[CmdletBinding(SupportsShouldProcess=$false)]
        param (
            [Parameter(Mandatory = $true, Position = 0)] 
            [string]$smtpServer,
            [Parameter(Mandatory = $true, Position = 1)]
            [string]$from,
            [Parameter(Mandatory = $true, Position = 2)]
            [string]$to,
            [Parameter(Mandatory = $true, Position = 3)]
            [string]$subject,
            [Parameter(Mandatory = $true, Position = 4)]
            [string]$body,
            [Parameter(Mandatory = $true, Position = 5)]
            [string]$port,
            [Parameter(Mandatory = $false, Position = 6, ParameterSetName = "usecred")] 
            [switch]$usecredential,
            [Parameter(Mandatory = $false, Position = 7, ParameterSetName = "usecred")]  
            [string]$emailaccount,
            [Parameter(Mandatory = $false, Position = 8, ParameterSetName = "usecred")]  
            [string]$password
            )

   if ($usecredential) 
   {
     Write-Verbose "With Credential"
     $secpasswd = ConvertTo-SecureString “$password” -AsPlainText -Force
     $credential = New-Object System.Management.Automation.PSCredential (“$emailaccount”, $secpasswd)
     Send-MailMessage -smtpServer $smtpServer -Credential $credential -from $from -to $to -subject $subject -Body $body -Usessl -Port $port
   }
   Else 
   {
     Write-Verbose "Without Credential"
     Send-MailMessage -smtpServer $smtpServer -from $from -to $to -subject $subject -Body $body -Usessl -Port $port
   }
}

function Send-UdfSecureMail  
{
[CmdletBinding(SupportsShouldProcess=$false)]
        param (
            [Parameter(Mandatory = $true)] 
            [string]$smtpServer,
            [Parameter(Mandatory = $true)]
            [string]$from,
            [Parameter(Mandatory = $true)]
            [string]$to,
            [Parameter(Mandatory = $true)]
            [string]$subject,
            [Parameter(Mandatory = $true)]
            [string]$body,
            [Parameter(Mandatory = $true)]
            [string]$port,
            [Parameter(Mandatory = $true)]  
            [string]$emailaccount,
            [Parameter(Mandatory = $true)]  
            [string]$credentialfilepath
            )

     $credin = Get-Content $credentialfilepath | convertto-securestring 

     write-verbose $credentialfilepath
    
     $credential = New-Object System.Management.Automation.PSCredential (“$emailaccount”,  $credin)

     Send-MailMessage -smtpServer $smtpServer -Credential $credential -from $from -to $to -subject $subject -Body $body -Usessl -Port $port
}


#  Load the Sales table...
function Invoke-UdfSalesTableLoad 
{ 
 [CmdletBinding()]
        param (
              [string] $path,   # Folder to be monitored
              [string] $filepattern    # File name pattern to wait for.
          )

$conn = new-object System.Data.SqlClient.SqlConnection("Data Source=(local);Integrated Security=SSPI;Initial Catalog=Development");
$conn.Open()

$command = $conn.CreateCommand()

#  Clear out the table first...
$command.CommandText = "truncate table dbo.sales;"
$command.ExecuteNonQuery()
Write-Verbose $path 
Write-Verbose $filepattern

$loadfilelist = Get-ChildItem $path $filepattern

$loadfilelist

foreach ($loadfile in $loadfilelist)
{

   $indata = Import-Csv $loadfile.FullName
   $indata 

   foreach ($row in $indata) 
   {

    $rowdata =  $row.SalesPersonID + ", '" + $row.FirstName + "', '" + $row.LastName + "', " + $row.TotalSales + ", '" + $row.AsOfDate + "', '" + $row.SentDate + "', '" + $row.filename + "'"
    
    Write-Verbose $rowdata
    
    $command.CommandText = "INSERT into dbo.sales VALUES ( " + $rowdata + ");"
    $command.ExecuteNonQuery() 
   }
}

$conn.Close()

}

# Example Call:
#    Invoke-UdfSalesTableLoad $processpath "sales*.csv" -Verbose

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

# Author:  Bryan Cafferky      Date:  2014-11-14
# 
# Purpose:  For loads of FTPed files.  Merge mmultiple files based on file name pattern matching and combine into one file so Informatica can load it.
#

function Add-UdfFile {
[CmdletBinding()]
        param (     
              [string] $source,  
              [string] $destination,
              [string] $filter  
          )

$filelist = Get-ChildItem -Path $source  $filter 

Write-Verbose $source

Write-Verbose "$filelist"

try
{
 Remove-Item $destination -ErrorAction SilentlyContinue
 Write-Verbose "Deleted $destination ."
 }
catch
 {
 Write-Verbose "Error:  Problem deleting old file."
 }


# Add-Content $destination "Column1`r`n"

  foreach ($file in $filelist)
  {
 
  Write-Verbose $file.FullName

  $fc = Get-Content $file.FullName

  Add-Content $destination $fc
  
  }

}
# Example Call:
#
# Add-UdfFile 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\' 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\combined.txt' 'o*.txt' -Verbose

function Add-UdfFileColumnHeading {
[CmdletBinding()]
        param (     
              [string] $sourcefile,  
              [string] $destinationfile,
              [string] $headingline  
          )

 if (Test-Path  $destinationfile)
 {
    Remove-Item $destinationfile -Force
    Write-Verbose "Deleted $destinationfile ."
 }

 Add-Content $destinationfile "$headingline"

 $fc = Get-Content  $sourcefile

 Add-Content $destinationfile $fc
}

# Example Call:
#
# Add-UdfFileColumnHeading 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\outfile1.txt' 'C:\Users\BryanCafferky\Documents\BI_UG\PowerShell\Examples\Data\filewithheadings.txt' "firstname,lastname,street,city,state,zip" -Verbose
          
function Add-UdfMapping { 
 [CmdletBinding()]
        param (
              [string]   $incolumn              , # Column from input pipeline.
              [string]   $outcolumn             , # Output column name.
              [string]   $outcolumndelimiter    , # Character to delimit output column.  
              [boolean]  $iskey                   # True = Key column, False = Not key column
          )

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
  
function Get-UdfOutColumnList 
{ 
 [CmdletBinding()]
        param (
                 [psobject] $mapping          
          )
   $outlist = ""                            # Just intializing
   foreach ($value in $mapping)
   {
     $outlist += $value.OutColumn + ", " 
 #    Write-Host "Outfield is $value"
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
        $sqldml = "insert into $destinationtablename (" + (Get-UdfOutColumnList $mapping) + ") values (`$valuelist);" ; break
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
                            [ValidateSet("Insert","Update","Merge","Delete")]
                 [string]   $dmloperation,
                 [Parameter(ValueFromPipeline=$False,Mandatory=$True,Position=3)]
                 [string]   $destinationtablename,
                 [psobject] $connection
                 
               )

    begin 
    { 
     $sqldml = Get-UdfSQLDML $mapping -dmloperation $dmloperation "$destinationtablename"
     $dbconn = Get-UdfADOConnection $connection
     $command = new-object system.data.sqlclient.Sqlcommand($dbconn)
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
        $command.ExecuteNonQuery()    | Out-Null 
    }
            
    end 
    {
        $dbconn.Close() 
    }

}

function Search-UdfFile ([string]$searchstring,[string] $outfilepath)
{
  begin
  {
   "" > $outfilepath  # Clear out file contents
  }
  process 
  {
   if ($_ -like "*$searchstring*")
   {
    $_ >> $outfilepath
   }
  }
}

function Invoke-UdfStateTaxFileTransformation 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$mypipe = "default"                 
               )
    process 
    {  
       
      $mypipe | Add-Member -MemberType NoteProperty -Name "Country" -Value "US" 
      
      if ($mypipe.StateCode -eq "MA" ) { $mypipe.SalesTaxRate = .08 } 
       
      Return $mypipe
    }            
} 

function Add-UdfColumnNameToFile 
{
[CmdletBinding(SupportsShouldProcess=$true)]
        param (
            [string]$sourcepath,
            [string]$targetpath,
            [string]$filter 
          )

      Write-Verbose $sourcepath
      Write-Verbose $targetpath
      Write-Verbose $filter

      $filelist = Get-ChildItem -Path $sourcepath -Filter $filter

      foreach ($file in $filelist)
      {
        $csv = get-content ($sourcepath + $file)
        
        $start = 0
     
        $file_wo_comma = $file.name.Replace(',','_')
        $file_wo_comma = $file_wo_comma.Replace(' ','')
     
        $targetpathandfile = $targetpath +  $file_wo_comma  
        $targetpathandfile  
     
        foreach ($line in $csv)
           {
           if ($start -eq 0) 
               {
                 $line += ",filename"
                 $line > $targetpathandfile 
               }
           else
               {
                 $line +=",$file_wo_comma"
                 $line >> $targetpathandfile 
               }
         
           $start = 1
     
           }   
        }   
}

# Add-UdfColumnNameToFile ($unzippedpath + "\")  $processpath "sales*.csv" -Verbose

# dir  $unzippedpath -Filter "sales*.sv"
