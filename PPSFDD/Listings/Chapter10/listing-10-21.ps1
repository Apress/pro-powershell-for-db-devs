Import-Module umd_etl_functions

# Wait for the files...
Wait-UdfFileCreation $global:ftppath  -Verbose 

# Notify users the job has started using Outlook...
Send-UdfMail  -Server $global:mailserver -From $global:fromemail -To $global:toemail `
               –Subject "ETL Job: Sales Load has started" –Body "The ETL Job: Sales Load has started." `
               –Port $global:emailport -usecredential $global:emailaccount –Password $global:emailpw

# Copy the files...
Copy-UdfFile $ global:ftppath $global:inbound -overwrite

$filelist = Get-ChildItem $global:zippath

#  Unzip the files...
Foreach ($file in $filelist)  
{
   Expand-UdfFile $file.FullName $global:unzippedpath -force
}

# Add file name to file...
Add-UdfColumnNameToFile $global:unzippedpath  $global:processpath "sales*.csv"

# Load the files...
Invoke-UdfSalesTableLoad $global:processpath "sales*.csv" -Verbose

# Archive files...
Move-UdfFile $global:ftppath $global:archivepath  -overwrite

# Notify users the job has finished...
Send-UdfMail  -Server $global:mailserver -From $global:fromemail -To $global:toemail `
               –Subject "ETL Job: Sales Load has ended" –Body "The ETL Job: Sales Load has ended." `
               –Port $global:emailport -usecredential $global:emailaccount –Password $global:emailpw
