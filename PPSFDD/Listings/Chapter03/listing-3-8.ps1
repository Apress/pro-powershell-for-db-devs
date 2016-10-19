function Invoke-UdfSQLScript 
([string] $p_server, [string] $p_dbname, [string] $logpath)

{

 begin 
 { 
   if(-not(Get-Module -name "sqlps")) { Import-Module "sqlps" } 

   set-location "SQLSERVER:\SQL\$p_server\DEFAULT\Databases\$p_dbname\"
   write-host $p_server $p_dbname
   "Deployment Log:  Server: $p_server Target Datbase: $p_dbname Date/Time: " `
    + (Get-Date)  + "`r`n" > $logpath  
    # > means create/overwrite and >> means append.
   }

  process 
  { 
   Try 
     {
      $filepath = $_.fullname   # grab this so we can write it out in the Catch block.
      $script = Get-Content  $_.fullname       # Load the script into a variable.  
      write-host $filepath 
      Invoke-Sqlcmd -Query  "$script ;" -QueryTimeout 3 
      "Script: $filepath successfully processed. " >> $logpath 
      }
      Catch 
      {
        write-host "Error processing script: $filepath . Deployment aborted." 
        Continue
      }               
   }         

   end 
   {  
     "`r`nEnd of Deployment Log:  Server: $p_server Target Datbase: $p_dbname Finished Date/Time: " + (Get-Date)  + "`r`n" >> $logpath 
   }
}

# Lines to call the function.  Passing paramters positionally…

# Change $scriptpath to point to where the SQL scripts are located.
# Change $logpath to where you want the log file created.
cls
$datapath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"
$scriptpath = $datapath + "*.sql"
$logpath    = $datapath + "deploy1_log.txt" 

Get-ChildItem -Path $scriptpath | Invoke-UdfSQLScript "(local)" "AdventureWorks" $logpath 
