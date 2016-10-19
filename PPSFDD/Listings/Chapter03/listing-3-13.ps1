function Register-UdfFileCreateEvent([string] $source, [string] $filter)
{
   try
   {
     Write-Host "Watching $source for new files..."

     $fsw = New-Object IO.FileSystemWatcher $source, $filter -Property @{IncludeSubdirectories = $false; NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

     Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
     write-host "Your file has arrived."   }

    }
   catch
    {
      "Error registering file create event."
    }
} 

$datapath = $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"
Register-UdfFileCreateEvent $datapath "*.txt"
