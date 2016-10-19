Import-Module “sqlps” -DisableNameChecking

$outpath =  $env:HOMEDRIVE + $env:HOMEPATH + "\Documents\storedprocedures.sql"

# Let's clear out the output file first.
"" > $outpath

# Set where you are in SQL Server...
set-location SQLSERVER:\SQL\BryanCafferkyPC\DEFAULT\Databases\Adventureworks\StoredProcedures

foreach ($Item in Get-ChildItem) 
{
    $Item.Schema + "_" + $Item.Name 
    $Item.Script() | Out-File -Filepath $outpath -append
} 
