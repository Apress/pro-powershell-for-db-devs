New-EventLog -LogName DataWarehouse -Source ETL 

Limit-EventLog -LogName DataWarehouse -MaximumSize 10MB -RetentionDays 10

For ($i=1; $i -le 5; $i++) 
{  
   Write-EventLog -LogName DataWarehouse -Source ETL -EventId 9999 -Message ("DW Event written " + (Get-Date)) 
}

Get-EventLog -LogName DataWarehouse 
