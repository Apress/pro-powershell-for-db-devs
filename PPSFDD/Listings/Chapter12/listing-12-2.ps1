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
<#  Example call...change path to your SQL Server Instance #>
Invoke-UdfSQLAgentJob -sqlserverpath 'SQLSERVER:\SQL\BryanCafferkyPC\DEFAULT\JobServer\Jobs\'
