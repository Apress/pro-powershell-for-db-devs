function Register-UdfFileCreateEvent([string] $source, [string] $filter)
{
   try
   {
     Write-Host "Watching $source for new files..."
     $filesystemwatcher = New-Object IO.FileSystemWatcher $source, 
     $filter -Property @{IncludeSubdirectories = $false; NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}
     Register-ObjectEvent $filesystemwatcher Created -SourceIdentifier FileCreated -Action {
     write-host "Your file has arrived. The file name is " $Event.SourceEventArgs.Name "."   }
    }
   catch
    {
      "Error registering file create event."
    }
}  

Register-UdfFileCreateEvent ($env:HOMEDRIVE + $env:HOMEPATH + "\Documents\") "*.txt"   
