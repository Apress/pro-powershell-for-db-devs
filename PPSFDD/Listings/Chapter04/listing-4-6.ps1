$sourcepath =  $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\"

#  Let's trap any errors...
trap { "Error Occurred: $Error." >> ($sourcepath + "errorlog.txt") }

$file = Get-Content ($sourcepath + "script.sql") -ErrorAction Stop

$file = $file.replace('[HumanResources].[Department]', '[HumanResources].[CompanyUnit]');

#  Load the column Mappings...
$incolumnemapping = Import-CSV ($sourcepath + "columnmapping.csv")

foreach ($item in $incolumnemapping) { $file = $file.replace(($item.SourceColumn), ($item.TargetColumn) ) }

Try 
{
   $file >  ($sourcepath + "script_revised.sql")
   "File script.sql has been processed."
}
Catch
{
   "Error Writing file Occurred: $Error." >> ($sourcepath + "errorlog.txt")
}
Finally
{
   "Mapping process executed on " + (Get-Date) + "." >> ($sourcepath + "executionlog.txt")
}  
