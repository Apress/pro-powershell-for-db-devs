Import-Module umd_etl_functions -Force
Clear-Host

$rootfolder = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents"
$ftppath = $rootfolder + "\FTP\sales_*.zip"
$inbound =  $rootfolder + "\Inbound\"
$zippath = $inbound + "\sales_*.zip"
$unzippedpath = $rootfolder + "\unzipped\"
$processpath = $rootfolder + "\Process\"
$archivepath = $rootfolder + "\Archive\"

# Wait for the files...
Wait-UdfFileCreation $ftppath  -Verbose 

# Notify users the job has started using Outlook...
Send-UdfMail  "smtp.live.com" "emailaddress@msn.com" "emailaddress@msn.com" "ETL Job: Sales Load has Started" "The ETL Job: Sales Load has started." "587" -usecredential "emailaddress@msn.com" "password"

# Copy the files...
Copy-UdfFile $ftppath $inbound -overwrite

$filelist = Get-ChildItem $zippath

#  Unzip the files...
Foreach ($file in $filelist)  
{
   Expand-UdfFile $file.FullName $unzippedpath -force
}

# Add file name to file...
Add-UdfColumnNameToFile $unzippedpath  $processpath "sales*.csv" -Verbose

# Load the files...
Invoke-UdfSalesTableLoad $processpath "sales*.csv" -Verbose

# Archive files...
Move-UdfFile $ftppath $archivepath  -overwrite

# Notify users the job has finished...
Send-UdfMail  "smtp.live.com" "emailaddress@msn.com" "emailaddress@msn.com" "ETL Job: Sales Load has ended" "The ETL Job: Sales Load has ended." "587" -usecredential "emailaddress@msn.com" "password"
