Import-Module umd_database
Import-module umd_northwind_etl
Import-Module umd_etl_functions

[psobject] $global:SqlServer1 = New-Object psobject
New-UdfConnection ([ref]$SqlServer1) 

$global:SqlServer1.ConnectionType = 'ADO'
$global:SqlServer1.DatabaseType = 'SqlServer'
$global:SqlServer1.Server = '(local)'
$global:SqlServer1.DatabaseName = 'Development'
$global:SqlServer1.UseCredential = 'N'
$global:SqlServer1.SetAuthenticationType('Integrated')
$global:SqlServer1.BuildConnectionString()

<#  Send Order Load Email... #>
function Send-UdfOrderLoadEmail ([string]$subject, [string]$body)
{
   $credin = Get-Content ($global:rootfilepath + 'bryan') | convertto-securestring 
   $credential = New-Object System.Management.Automation.PSCredential `
                 (“bryan@msn.com”,  $credin)
   Send-MailMessage -smtpServer smtp.live.com -Credential $credential `
   -from 'bryan@msn.com'  -to 'bryan@msn.com' -subject "$subject" `
   -Body "$body" -Usessl -Port 587
} 


<#  Order Load Workflow... #>
Workflow Invoke-UdwOrderLoad  
{
 param([string] $sourceidentifier, [string] $sqlserver, [string] $databasename ) 

 sequence 
 { 
    Write-Verbose $sourceidentifier
    Invoke-UdfOrderLoad

    $missing_emps = Get-UdfMissingEmployee | Where-Object -Property Employee_ID -ne $null 

    if ($missing_emps.Count -gt 0) 
    {
     Write-Verbose "Workflow Being Suspended."

<#  Mail commented out - uncomment after the function has been updated.
    Send-UdfOrderLoadEmail -subject "ETL Job Order Load - Suspended"  `
    -body "The ETL Job: Order Load has been suspended because the employee 
     file has not been loaded. Please send the employee file as soon
     as possible."
#>

     Checkpoint-Workflow
     Suspend-Workflow      
     Write-Verbose "Workflow Resumed."
     Invoke-UdfEmployeeLoad
<#  Mail commented out - uncomment after the function has been updated.
     Send-UdfOrderLoadEmail -subject "ETL Job Order Load"  `
                              -body "The ETL Job: Order Load has ended."
#>
}
 Else
 {
  Write-Verbose "finish"

  Invoke-UdfSQLQuery -sqlserver '(local)' -sqldatabase 'development' `
  -sqlquery "update [dbo].[WorkFlowLog] set Status = 'complete' `
  where WorkflowName = 'OrderLoad' and Status = 'suspended';"   

 # Send-UdfOrderLoadEmail -subject "ETL Job Order Load"  `
 #                        -body "The ETL Job: Order Load has ended."
 }     
}
}

<#  Log the Workflow Transformation.. #>
function  Invoke-UdfWorkflowLogTransformation 
{ 
 [CmdletBinding()]
        param (
                 [Parameter(ValueFromPipeline=$True)]$pipein = "default" 
                )
    process 
    {  

       $pipein | Add-Member -MemberType NoteProperty -Name "WorkflowName"    `
                            -Value "OrderLoad" 
       Return $pipein
    }            
}  


<#  Run the Workflow... #>
function Invoke-UdfWorkflow ()
{
<#  Define the mapping... #>
   $mappingset = @()  # Create a collection object.
   $mappingset += (Add-UdfMapping "WorkflowName" "WorkflowName" "'" $false) 
   $mappingset += (Add-UdfMapping "ID" "JobID" "" $false)
   $mappingset += (Add-UdfMapping "Name" "JobName" "'" $false) 
   $mappingset += (Add-UdfMapping "Location" "Location" "'" $false) 
   $mappingset += (Add-UdfMapping "Command" "Command" "'" $false) 

    Try 
    {
      Invoke-UdwOrderLoad  -sourceidentifier 'Order' -sqlserver $global:SqlServer1.Server `
                           -databasename $global:SqlServer1.Databasename `
                           -AsJob -JobName OrderLoad | Invoke-UdfWorkflowLogTransformation |     
                           Select-Object -Property WorkflowName, ID, Name, Location, Command | 
                           Invoke-UdfSQLDML -Mapping $mappingset  -DmlOperation "Insert"  `
                           -Destinationtablename "dbo.WorkFlowLog" `
                           -Connection $global:SqlServer1 -Verbose 
       }
       Catch
       {
       "Error:  $error"
       }
}

<#  Resume Workflow #>
function Resume-UdfWorkflow ()
{ 
    Try 
    {     
      $job = Invoke-UdfSQLQuery -sqlserver $global:SqlServer1.Server `
             -sqldatabase 'development' `
             -sqlquery "select JobID from [dbo].[WorkFlowLog] where WorkflowName = 'OrderLoad'     
              and Status = 'suspended';" `  

      Resume-Job -id $job.JobID -Wait

      Invoke-UdfSQLQuery -sqlserver  $global:SqlServer1.Server `
                        –sqldatabase $global:SqlServer1.DatabaseName `
      -sqlquery "update [dbo].[WorkFlowLog] set Status = 'complete' where WorkflowName = 
       'OrderLoad' and Status = 'suspended';" `  

    }
    Catch
    {
      "Error:  $error"
    }
} 

<# Register Order File Create Event #>
function Register-UdfOrderFileCreateEvent([string] $source, [string] $filter, [string]$sourceidentifier)
{
   try
   {
     $filesystemwatcher = New-Object IO.FileSystemWatcher $source, $filter -Property  `
     @{IncludeSubdirectories = $false; NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}
     Register-ObjectEvent $filesystemwatcher Created -SourceIdentifier $sourceidentifier `
                          -Action { Invoke-UdfWorkflow }
    }
   catch
    {
      "Error registering file create event."
    }
} 

<# Register Employee File Create Event #>
function Register-UdfEmployeeFileCreateEvent([string] $source, [string] $filter, [string] $sourceidentifier)
{
   try
   {
     $filesystemwatcher = New-Object IO.FileSystemWatcher $source, $filter -Property  `
     @{IncludeSubdirectories = $false; NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

     Register-ObjectEvent $filesystemwatcher Created -SourceIdentifier $sourceidentifier `
                          -Action { Resume-UdfWorkflow }
    }
   catch
    {
      "Error registring file create event."
    }
} 

<#   
   Poor Man's Hadoop functions start here...
#>

$filepath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"

function New-UdfFile ([string]$fullfilepath)
{
  for ($i=1; $i -le 1000; $i++)
  {
    Get-ChildItem | Out-File ($fullfilepath) -Append
  } 
}

<# Use lines below to create test files... 
New-UdfFile ($filepath + "logfile1.txt")
New-UdfFile ($filepath + "logfile2.txt")
#>

<#  Search file... #>
workflow Search-UdwFile ([string]$filepath, $filelist, $searchstring)
{
   foreach -parallel ($file in $filelist)
   {
     Write-Verbose 'Processing searches...'

     inlinescript 
       { 
         function Search-UdfSingleFile ([string]$searchstring,[string] $outfilepath)
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

         $sourcefile = $using:filepath + $using:file ;
         $outfile = $using:filepath + "out_" + $using:file ;
         "Writing output to $outfile."
         Get-Content $sourcefile  | 
         Search-UdfSingleFile -searchstring  $using:searchstring -outfilepath $outfile 
       }
   }
}


